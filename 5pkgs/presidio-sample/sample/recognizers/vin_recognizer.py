from typing import List, Optional
import tldextract
from presidio_analyzer import Pattern, PatternRecognizer


class VINRecognizer(PatternRecognizer):
    """
    Recognize email addresses using regex.
    :param patterns: List of patterns to be used by this recognizer
    :param context: List of context words to increase confidence in detection
    :param supported_language: Language this recognizer supports
    :param supported_entity: The entity this recognizer can detect
    """

    PATTERNS = [
        Pattern(
            "VIN Number (Medium)",
            # r".*",
            "(([a-hA-Hj-nJ-Np-zP-Z0-9]{9})([a-hA-Hj-nJ-NpPr-tR-Tv-zV-Z0-9])([a-hA-Hj-nJ-Np-zP-Z0-9])(\\d{6}))",  # noqa: E501
            0.5,
        ),
    ]
    CONTEXT = []

    def __init__(
        self,
        patterns: Optional[List[Pattern]] = None,
        context: Optional[List[str]] = None,
        supported_language: str = "de",
        supported_entity: str = "VIN_Number",
    ):
        patterns = patterns if patterns else self.PATTERNS
        context = context if context else self.CONTEXT
        super().__init__(
            supported_entity=supported_entity,
            patterns=patterns,
            context=context,
            supported_language=supported_language,
        )
