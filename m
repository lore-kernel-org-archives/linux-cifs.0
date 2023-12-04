Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZQ1TjyN+"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA10106
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:51:39 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1d05e4a94c3so25583005ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701697898; x=1702302698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nhsR47NQqcsB+hF3MEiVjLTWyDrKXr3SCjTnGdW0LC4=;
        b=ZQ1TjyN+IMlrOf8ASbIAGHOP4EL0Z30ZHqnZ1dZpPghU+VXhnfYamL8iQmZvPrFH2/
         G5ovT2WKCbg5r1qYzPKkobfns32M5do347Ivu9VSHOhRjW57UoAovY0jx3MbBXIYQniQ
         VZCoSa67pI42sp0DOWrTtZDyALuYYydZxjDmDfBJx5Fovz7yK1B0R/U0TCRS4hyeACej
         MaOfsaAJyvOXseAfte85AcRkX0y1Wnm3TEi2C+4LZMqKsfoysfuZdZ9Y0kyw/gMsTK/Y
         KM6hpdlsqimCtwU0KH5jQiLPkknsWCBjnkQ3dQNeOjdiTSWD5ZTdGNUHb9u40Ixu5iie
         OvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697898; x=1702302698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhsR47NQqcsB+hF3MEiVjLTWyDrKXr3SCjTnGdW0LC4=;
        b=GT347Ay2WJHFDwoe0kQuJmf6wIe3F+nahwOPBfQvq4w3m7X3WP6NTcvo/gHgwi0ZGG
         SK29rJBGhTEVgvCYefWol4Kg2MRg8adZD8Jo6UYZMRQ3RSZwCLnRyTzIdp6fY9Lt2qdw
         skWUqUSZAMpEwniAVI0PeZG4/DsEsVpaGu07XbaVdaTowDBSQ18zyiTAf56PHnYfGtZg
         anrdK2fcPNScmrtM4qdyk8Ze7p6c5RwupOdmFEBbo7WCkuxiPbmfJFSn5wpQQzNJEcii
         h89JC9Gfrl1fKPzB1nTFyGqjOgdX4Z7YMqTVSf4NHpwTNgZfuXaOY+/DFY2INAv5lJ+o
         9dlA==
X-Gm-Message-State: AOJu0Yy1kMkPgitrL6Y/B+C2QuleL7Rp8d/GumfXM3/bKPj0IuB+foIm
	UMMEQih3Vtlx/zf/pYQcKhpnW/TNIUPbQLm4J94=
X-Google-Smtp-Source: AGHT+IGpZRU6Qq//lUtmdB6JjrukeFfiGMamCDzG3vRZ0jBeM1IzZgY0HzZ4UZfMdZGkRxSqQbc5OQ==
X-Received: by 2002:a17:903:2350:b0:1d0:6ffe:a02 with SMTP id c16-20020a170903235000b001d06ffe0a02mr4864795plh.96.1701697898163;
        Mon, 04 Dec 2023 05:51:38 -0800 (PST)
Received: from localhost.localdomain ([124.123.164.183])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902f68600b001c72d5e16acsm8450176plg.57.2023.12.04.05.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:51:37 -0800 (PST)
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: linux-cifs@vger.kernel.org,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	lkft-triage@lists.linaro.org,
	linux-kernel@vger.kernel.org
Cc: amir73il@gmail.com,
	mszeredi@redhat.com,
	ebiggers@google.com,
	krisman@collabora.com,
	dhowells@redhat.com,
	sfrench@samba.org,
	hch@lst.de,
	pc@manguebit.com,
	nspmangalore@gmail.com,
	rohiths.msft@gmail.com,
	willy@infradead.org,
	jlayton@kernel.org,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: "copy_file_range03.c:52: TFAIL: diff_us = 0, copy_file_range might not update timestamp"
Date: Mon,  4 Dec 2023 19:21:27 +0530
Message-Id: <20231204135127.40002-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The LTP syscalls copy_file_range01 and copy_file_range03 failed on all devices
running Linux next-20231204 kernel.

## Test Regressions (compared to next-20231201)
* qemu-arm64, ltp-syscalls
* e850-96, ltp-syscalls
* x15, ltp-syscalls
* x86, ltp-syscalls
  - copy_file_range01
  - copy_file_range03


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Test log:
-------  

tst_test.c:1119: TINFO: Mounting /dev/loop0 to 
       /scratch/ltp-XLc1JftiUn/LTP_copns9ldR/mnt_point fstyp=ext2 flags=0
copy_file_range.h:36: TINFO: Testing libc copy_file_range()
Test timeouted,sending SIGKILL!
[ ] EXT4-fs (loop0): unmounting filesystem c58dd839-66b3-4c79-81f7-9cc9a7ed0dfd.
tst_test.c:1628: TINFO: If you are running on slow machine, try exporting LTP_TIMEOUT_MUL > 1
tst_test.c:1630: TBROK: Test killed! (timeout?)

<trim>

tst_test.c:1690: TINFO: LTP version: 20230929
tst_test.c:1574: TINFO: Timeout per run is 0h 05m 00s
copy_file_range.h:36: TINFO: Testing libc copy_file_range()
copy_file_range03.c:52: TFAIL: diff_us = 0, copy_file_range might not update timestamp

Links:
 - https://lkft.validation.linaro.org/scheduler/job/7077286#L37034
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20231204/testrun/21474387/suite/ltp-syscalls/test/copy_file_range03/log
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20231204/testrun/21474387/suite/ltp-syscalls/test/copy_file_range03/history/
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20231204/testrun/21474387/suite/ltp-syscalls/test/copy_file_range01/history/


--
Linaro LKFT
https://lkft.linaro.org
