// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MilkQualityControl {

    // Events
    event NewMeasurement(
        string milkId,
        string stage,
        string test,
        string result,
        uint timestamp
    );
    event MeasurementUpdate(
        string milkId,
        string stage,
        string test,
        string newResult,
        uint timestamp
    );

    // Mapping from milk ID to milk information
    mapping(string => Milk) public milk;

    struct Milk {
        mapping(string => mapping(string => Measurement)) measurements;
        mapping(string => bool) measurementUpdatable;
        mapping(string => uint) measurementTimestamps;
    }

    struct Measurement {
        string result;
    }

    // Add a new measurement for a milk
    function addMeasurement(
        string memory _milkId,
        string memory _stage,
        string memory _test,
        string memory _result
    ) public {
        milk[_milkId].measurements[_stage][_test] = Measurement(_result);
        milk[_milkId].measurementUpdatable[_test] = true;
        milk[_milkId].measurementTimestamps[_test] = block.timestamp;
        emit NewMeasurement(_milkId, _stage, _test, _result, block.timestamp);
    }
    function updateMeasurement(
        string memory _milkId,
        string memory _stage,
        string memory _test,
        string memory _newResult
    ) public {
        require(milk[_milkId].measurementUpdatable[_test] == true, "Cannot update measurement");
        milk[_milkId].measurements[_stage][_test].result = _newResult;
        milk[_milkId].measurementTimestamps[_test] = block.timestamp;
        milk[_milkId].measurementUpdatable[_test] = false;
        emit MeasurementUpdate(_milkId, _stage, _test, _newResult, block.timestamp);
    }

    function getMeasurement(string memory _milkId, string memory _stage, string memory _test) public view returns (Measurement memory) {
        return milk[_milkId].measurements[_stage][_test];
    }
}
