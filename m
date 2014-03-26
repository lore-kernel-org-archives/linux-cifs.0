From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Wed, 26 Mar 2014 22:06:53 +0900
Message-ID: <201403262206.CDJ48478.QOFSMOtFJVOFHL@I-love.SAKURA.ne.jp>
References: <201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
	<20140320191013.110276c0@tlielax.poochiereds.net>
	<201403262104.AGG86982.StVMOJOHFOQFLF@I-love.SAKURA.ne.jp>
	<20140326052119.32405279@ipyr.poochiereds.net>
	<20140326060305.3226a08c@ipyr.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	samba-technical@lists.samba.org
To: jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140326060305.3226a08c@ipyr.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Jeffrey Layton wrote:
> ...or maybe it *is* cifs.ko.

The strace log is showing that smbd process receives "\377SMB." for read()
request and "\377SMB2" for fstat() request.
We can see that there is only one "\377SMB." between two "\377SMB2" for
delay = 1000 ms case while there are multiple "\377SMB." between two
"\377SMB2" for delay = 0 ms case.

Therefore, I think it *is* cifs.ko.

---------- strace of normal case ----------
21:38:47.725757 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 53516) = 1 ([{fd=25, revents=POLLIN}])
21:38:47.725847 read(25, "\0\0\0;", 4)  = 4
21:38:47.725901 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0c\32"..., 59) = 59
21:38:47.725970 fstat(29, {st_mode=S_IFREG|0644, st_size=1, ...}) = 0
21:38:47.726039 pread(29, ".", 1, 0)    = 1
21:38:47.726095 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 64}], 1) = 64
21:38:47.726187 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 53514) = 1 ([{fd=25, revents=POLLIN}])
21:38:48.739627 read(25, "\0\0\0b", 4)  = 4
21:38:48.739725 read(25, "\377SMB2\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0d\32"..., 98) = 98
21:38:48.739811 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=1, ...}) = 0
21:38:48.739902 getcwd("/root", 4096)   = 6
21:38:48.739956 lstat("/root/shared_file", {st_mode=S_IFREG|0644, st_size=1, ...}) = 0
21:38:48.740039 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=1, ...}) = 0
21:38:48.740111 fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:48.740171 fcntl(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:48.740241 writev(25, [{"\0\0\0\240\377SMB2\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 164}], 1) = 164
21:38:48.740341 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 52500) = 1 ([{fd=25, revents=POLLIN}])
21:38:48.740459 read(25, "\0\0\0;", 4)  = 4
21:38:48.740515 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0e\32"..., 59) = 59
21:38:48.740578 fstat(29, {st_mode=S_IFREG|0644, st_size=2, ...}) = 0
21:38:48.740643 pread(29, ".", 1, 1)    = 1
21:38:48.740698 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 64}], 1) = 64
21:38:48.740789 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 52499) = 1 ([{fd=25, revents=POLLIN}])
21:38:49.755256 read(25, "\0\0\0b", 4)  = 4
21:38:49.755330 read(25, "\377SMB2\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0f\32"..., 98) = 98
21:38:49.755412 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=2, ...}) = 0
21:38:49.755484 getcwd("/root", 4096)   = 6
21:38:49.755538 lstat("/root/shared_file", {st_mode=S_IFREG|0644, st_size=2, ...}) = 0
21:38:49.755603 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=2, ...}) = 0
21:38:49.755674 fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:49.755733 fcntl(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:49.755802 writev(25, [{"\0\0\0\240\377SMB2\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 164}], 1) = 164
21:38:49.755945 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 51484) = 1 ([{fd=25, revents=POLLIN}])
21:38:49.756007 read(25, "\0\0\0;", 4)  = 4
21:38:49.756058 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0g\32"..., 59) = 59
21:38:49.756120 fstat(29, {st_mode=S_IFREG|0644, st_size=3, ...}) = 0
21:38:49.756185 pread(29, ".", 1, 2)    = 1
21:38:49.756240 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 64}], 1) = 64
21:38:49.756331 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 51484) = 1 ([{fd=25, revents=POLLIN}])
21:38:50.770753 read(25, "\0\0\0b", 4)  = 4
21:38:50.770838 read(25, "\377SMB2\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5d\0h\32"..., 98) = 98
21:38:50.770922 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=3, ...}) = 0
21:38:50.770994 getcwd("/root", 4096)   = 6
21:38:50.771050 lstat("/root/shared_file", {st_mode=S_IFREG|0644, st_size=3, ...}) = 0
21:38:50.771115 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=3, ...}) = 0
21:38:50.771187 fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:50.771247 fcntl(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:38:50.771316 writev(25, [{"\0\0\0\240\377SMB2\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0\32\5"..., 164}], 1) = 164
21:38:50.771461 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 50469) = 1 ([{fd=25, revents=POLLIN}])
---------- strace of normal case ----------

---------- strace of problem case ----------
21:40:36.663289 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4638) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.663349 read(25, "\0\0\0b", 4)  = 4
21:40:36.663399 read(25, "\377SMB2\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\227\34"..., 98) = 98
21:40:36.663463 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=447, ...}) = 0
21:40:36.663528 getcwd("/root", 4096)   = 6
21:40:36.663578 lstat("/root/shared_file", {st_mode=S_IFREG|0644, st_size=447, ...}) = 0
21:40:36.663642 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=447, ...}) = 0
21:40:36.663708 fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:40:36.663761 fcntl(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:40:36.663867 writev(25, [{"\0\0\0\240\377SMB2\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 164}], 1) = 164
21:40:36.664038 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4637) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.664102 read(25, "\0\0\0;", 4)  = 4
21:40:36.664154 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\230\34"..., 59) = 59
21:40:36.664215 fstat(29, {st_mode=S_IFREG|0644, st_size=448, ...}) = 0
21:40:36.664277 pread(29, ".", 1, 447)  = 1
21:40:36.664330 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 64}], 1) = 64
21:40:36.664438 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4637) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.664498 read(25, "\0\0\0;", 4)  = 4
21:40:36.664548 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\231\34"..., 59) = 59
21:40:36.664608 fstat(29, {st_mode=S_IFREG|0644, st_size=449, ...}) = 0
21:40:36.664669 pread(29, ".", 1, 448)  = 1
21:40:36.664719 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 64}], 1) = 64
21:40:36.664824 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4636) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.664883 read(25, "\0\0\0;", 4)  = 4
21:40:36.664933 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\232\34"..., 59) = 59
21:40:36.664992 fstat(29, {st_mode=S_IFREG|0644, st_size=450, ...}) = 0
21:40:36.665053 pread(29, ".", 1, 449)  = 1
21:40:36.665102 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 64}], 1) = 64
21:40:36.665206 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4636) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.665265 read(25, "\0\0\0;", 4)  = 4
21:40:36.665315 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\233\34"..., 59) = 59
21:40:36.665374 fstat(29, {st_mode=S_IFREG|0644, st_size=451, ...}) = 0
21:40:36.665435 pread(29, ".", 1, 450)  = 1
21:40:36.665484 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 64}], 1) = 64
21:40:36.665587 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4636) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.665646 read(25, "\0\0\0;", 4)  = 4
21:40:36.665696 read(25, "\377SMB.\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\234\34"..., 59) = 59
21:40:36.665755 fstat(29, {st_mode=S_IFREG|0644, st_size=452, ...}) = 0
21:40:36.666556 pread(29, ".", 1, 451)  = 1
21:40:36.666613 writev(25, [{"\0\0\0<\377SMB.\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 64}], 1) = 64
21:40:36.666712 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4634) = 1 ([{fd=25, revents=POLLIN}])
21:40:36.666772 read(25, "\0\0\0b", 4)  = 4
21:40:36.666823 read(25, "\377SMB2\0\0\0\0\0\1\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5d\0\235\34"..., 98) = 98
21:40:36.666887 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=452, ...}) = 0
21:40:36.666951 getcwd("/root", 4096)   = 6
21:40:36.667000 lstat("/root/shared_file", {st_mode=S_IFREG|0644, st_size=452, ...}) = 0
21:40:36.667064 lstat("shared_file", {st_mode=S_IFREG|0644, st_size=452, ...}) = 0
21:40:36.667129 fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:40:36.667182 fcntl(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=13024, len=1}) = 0
21:40:36.667242 writev(25, [{"\0\0\0\240\377SMB2\0\0\0\0\200\3\300\0\0\0\0\0\0\0\0\0\0\0\0\1\0,\5"..., 164}], 1) = 164
21:40:36.667344 poll([{fd=6, events=POLLIN|POLLHUP}, {fd=25, events=POLLIN|POLLHUP}, {fd=8, events=POLLIN|POLLHUP}], 3, 4634) = 1 ([{fd=25, revents=POLLIN}])
---------- strace of problem case ----------
