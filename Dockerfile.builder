# ---- BUILDER IMAGE ----
FROM public.ecr.aws/lambda/provided:al2 as builder

RUN yum update -y && \
      yum groupinstall -y "Development Tools" && \
          yum install -y git wget ca-certificates python3-pip gtk2 libX11 libXext libXrender jq && \
              yum clean all

RUN pip3 install --upgrade pip && \
      pip3 install --upgrade cmake

WORKDIR /build
RUN git clone --depth 1 https://github.com/opencv/opencv.git

WORKDIR /build/opencv/build
RUN cmake -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
              -DBUILD_TESTS=ON \
                    -DBUILD_PERF_TESTS=OFF \
                          -DBUILD_LIST=core,ts,video \
                                .. && \
    make -j$(nproc)
