FROM python:3.12-bookworm

ENV DEBIAN_FRONTEND noninteractive

RUN pip install template-project-utils

COPY entrypoint.sh /entrypoint.sh
COPY run_test.sh /run_test.sh

ENTRYPOINT ["/entrypoint.sh"]
