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

const Map<AircraftStatus, String> enumToEnStringMap = {
  AircraftStatus.destroyedWrittenOff: "Destroyed, written off",
  AircraftStatus.substantialRepaired: "Substantial, repaired",
  AircraftStatus.substantial: "Substantial",
  AircraftStatus.substantialWrittenOff: "Substantial, written off",
  AircraftStatus.destroyed: "Destroyed",
  AircraftStatus.aircraftMissingWrittenOff: "Aircraft missing, written off",
  AircraftStatus.aircraftMissing: "Aircraft missing",
  AircraftStatus.minorRepaired: "Minor, repaired",
  AircraftStatus.minor: "Minor",
  AircraftStatus.minorWrittenOff: "Minor, written off",
  AircraftStatus.none: "None",
  AircraftStatus.noneRepaired: "None, repaired",
  AircraftStatus.unknown: "Unknown",
  AircraftStatus.unknownRepaired: "Unknown, repaired",
  AircraftStatus.unknownWrittenOff: "Unknown, written off",
  AircraftStatus.destroyedRepaired: "Destroyed, repaired",
  AircraftStatus.unknownUnknown: "UnknownUnknown",
  AircraftStatus.empty: "",
};

const Map<AircraftStatus, String> enumToStringMap = {
  AircraftStatus.destroyedWrittenOff: "aircraft_status_dw",
  AircraftStatus.substantialRepaired: "aircraft_status_sr",
  AircraftStatus.substantial: "aircraft_status_s",
  AircraftStatus.substantialWrittenOff: "aircraft_status_sw",
  AircraftStatus.destroyed: "aircraft_status_d",
  AircraftStatus.aircraftMissingWrittenOff: "aircraft_status_amw",
  AircraftStatus.aircraftMissing: "aircraft_status_am",
  AircraftStatus.minorRepaired: "aircraft_status_mr",
  AircraftStatus.minor: "aircraft_status_m",
  AircraftStatus.minorWrittenOff: "aircraft_status_mw",
  AircraftStatus.none: "aircraft_status_n",
  AircraftStatus.noneRepaired: "aircraft_status_nr",
  AircraftStatus.unknown: "aircraft_status_u",
  AircraftStatus.unknownRepaired: "aircraft_status_ur",
  AircraftStatus.unknownWrittenOff: "aircraft_status_uw",
  AircraftStatus.destroyedRepaired: "aircraft_status_dr",
  AircraftStatus.unknownUnknown: "aircraft_status_uu",
  AircraftStatus.empty: "aircraft_status_empty",
};
