# -*- coding: utf-8 -*-
import sys
import os

sys.path.append(os.path.abspath('.'))

from scratch.builders.dart_utils import write_topics_file
from scratch.builders.bio9_data_p1 import bio9_topics_p1
from scratch.builders.bio9_data_p2 import bio9_topics_p2
from scratch.builders.bio9_data_p3 import bio9_topics_p3
from scratch.builders.bio9_data_p4 import bio9_topics_p4
from scratch.builders.bio9_data_p5 import bio9_topics_p5
from scratch.builders.bio9_data_p6 import bio9_topics_p6

all_topics = (
    bio9_topics_p1 +
    bio9_topics_p2 +
    bio9_topics_p3 +
    bio9_topics_p4 +
    bio9_topics_p5 +
    bio9_topics_p6
)

print(f"Total topics collected: {len(all_topics)}")

# Verification
expected_ids = [f"bio_9_top{i:02d}" for i in range(1, 61)]
actual_ids = [t['id'] for t in all_topics]
assert actual_ids == expected_ids, f"IDs mismatch: {actual_ids} vs {expected_ids}"

comment = """Полный курс биологии 9 класса по официальному школьному учебнику
под редакцией В. В. Пасечника («Линия жизни», Просвещение).
Анатомия, физиология и гигиена человека: все 60 параграфов программы (§ 1 – § 60)."""

output_path = 'lib/data/biology_topics_9.dart'
write_topics_file(output_path, 'biologyTopics9', comment, all_topics)
print("Finished writing biology_topics_9.dart")
