enum AircraftStatus {
  destroyedWrittenOff, // Destroyed, written off
  substantialRepaired, // Substantial, repaired
  substantial, // Substantial
  substantialWrittenOff, // Substantial, written off
  destroyed, // Destroyed
  aircraftMissingWrittenOff, // Aircraft missing, written off
  aircraftMissing, // Aircraft missing
  minorRepaired, // Minor, repaired
  minor, // Minor
  minorWrittenOff, // Minor, written off
  none, // None
  noneRepaired, // None, repaired
  unknown, // Unknown
  unknownRepaired, // Unknown, repaired
  unknownWrittenOff, // Unknown, written off
  destroyedRepaired, // Destroyed, repaired
  unknownUnknown, // UnknownUnknown
  empty // Empty string ("")
}

const Map<String, AircraftStatus> stringToAircraftStatusMap = {
  "Destroyed, written off": AircraftStatus.destroyedWrittenOff,
  "Substantial, repaired": AircraftStatus.substantialRepaired,
  "Substantial": AircraftStatus.substantial,
  "Substantial, written off": AircraftStatus.substantialWrittenOff,
  "Destroyed": AircraftStatus.destroyed,
  "Aircraft missing, written off": AircraftStatus.aircraftMissingWrittenOff,
  "Aircraft missing": AircraftStatus.aircraftMissing,
  "Minor, repaired": AircraftStatus.minorRepaired,
  "Minor": AircraftStatus.minor,
  "Minor, written off": AircraftStatus.minorWrittenOff,
  "None": AircraftStatus.none,
  "None, repaired": AircraftStatus.noneRepaired,
  "Unknown": AircraftStatus.unknown,
  "Unknown, repaired": AircraftStatus.unknownRepaired,
  "Unknown, written off": AircraftStatus.unknownWrittenOff,
  "Destroyed, repaired": AircraftStatus.destroyedRepaired,
  "UnknownUnknown": AircraftStatus.unknownUnknown,
  "": AircraftStatus.empty,
};

const Map<AircraftStatus, String> enumToStringMap = {
  AircraftStatus.destroyedWrittenOff: "파괴됨, 폐기",
  AircraftStatus.substantialRepaired: "상당한 피해, 수리됨",
  AircraftStatus.substantial: "상당한 피해",
  AircraftStatus.substantialWrittenOff: "상당한 피해, 폐기",
  AircraftStatus.destroyed: "파괴됨",
  AircraftStatus.aircraftMissingWrittenOff: "항공기 실종, 폐기",
  AircraftStatus.aircraftMissing: "항공기 실종",
  AircraftStatus.minorRepaired: "경미한 피해, 수리됨",
  AircraftStatus.minor: "경미한 피해",
  AircraftStatus.minorWrittenOff: "경미한 피해, 폐기",
  AircraftStatus.none: "손상 없음",
  AircraftStatus.noneRepaired: "손상 없음, 수리됨",
  AircraftStatus.unknown: "알 수 없음",
  AircraftStatus.unknownRepaired: "알 수 없음, 수리됨",
  AircraftStatus.unknownWrittenOff: "알 수 없음, 폐기",
  AircraftStatus.destroyedRepaired: "파괴됨, 수리됨",
  AircraftStatus.unknownUnknown: "알 수 없는 상태",
  AircraftStatus.empty: "",
};
