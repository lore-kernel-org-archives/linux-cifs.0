From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Latest xfstest results
Date: Fri, 29 Aug 2014 10:33:14 -0500
Message-ID: <CAH2r5msh2j2qPsfNPsO2gMb8a_=snKUD=VpuAKhdMO_qopOsLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good progress on automated cifs.ko testing to Samba with Pavel's
changes to xfstest

Skipping test 285 (which I don't have enough disk space for in my
VMs).  Following is the test results of current cifs-2.6.git for-next
with (cifs enabled) xfstests to Samba (posix extensions enabled by
default)

Ran: generic/001 generic/002 generic/005 generic/006 generic/007
generic/011 generic/013 generic/014 generic/020 generic/023
generic/024 generic/028 generic/070 generic/074 generic/075
generic/088 generic/089 generic/091 generic/126 generic/127
generic/131 generic/133 generic/184 generic/192 generic/215
generic/221 generic/236 generic/237 generic/245 generic/246
generic/247 generic/248 generic/249 generic/257 generic/258
generic/263 generic/286 generic/308 generic/309 generic/310
generic/313 generic/315
Not run: generic/003 generic/004 generic/008 generic/009 generic/010
generic/012 generic/015 generic/016 generic/017 generic/018
generic/019 generic/021 generic/022 generic/025 generic/026
generic/027 generic/053 generic/062 generic/068 generic/069
generic/076 generic/077 generic/079 generic/083 generic/093
generic/097 generic/099 generic/100 generic/105 generic/112
generic/113 generic/117 generic/120 generic/123 generic/124
generic/125 generic/128 generic/129 generic/130 generic/132
generic/135 generic/141 generic/169 generic/193 generic/198
generic/204 generic/207 generic/208 generic/209 generic/210
generic/211 generic/212 generic/213 generic/214 generic/219
generic/223 generic/224 generic/225 generic/226 generic/228
generic/230 generic/231 generic/232 generic/233 generic/234
generic/235 generic/239 generic/240 generic/241 generic/251
generic/255 generic/256 generic/260 generic/269 generic/270
generic/273 generic/274 generic/275 generic/277 generic/280
generic/288 generic/294 generic/299 generic/300 generic/306
generic/307 generic/311 generic/312 generic/314 generic/316
generic/317 generic/318 generic/319 generic/320 generic/321
generic/322 generic/323 generic/324 shared/006 shared/032 shared/051
shared/272 shared/289 shared/298
Failures: generic/192 generic/215 generic/237 generic/258 generic/313
Failed 5 of 42 tests

For 192 delta1 time should be 40 (this seems to work intermittently)

QA output created by 192
sleep for 40
test
delta1 - access time after sleep in-core: 0
delta2 - access time after sleep on-disk: 40

QA output created by 215

creating test file
4096+0 records in
4096+0 records out

writing via mmap
FAIL: mtime not update after mapped write
FAIL: ctime not update after mapped write

QA output created by 237 (setfacl problem)
Expect to FAIL


QA output created by 258
Creating file with timestamp of Jan 1, 1960
Testing for negative seconds since epoch
Timestamp wrapped: 1409325798
Timestamp wrapped

QA output created by 313
Silence is golden
ctime not updated after truncate
mtime not updated after truncate





-- 
Thanks,

Steve
