From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/2] CIFS support for XFS test suite
Date: Sun, 24 Aug 2014 14:41:27 +0400
Message-ID: <CAKywueT-cYeotYBo1CGk1u2+bLN28OUjm5hpfo5xgQ=DFFV42g@mail.gmail.com>
References: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
	<20140823114950.GB24896@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140823114950.GB24896-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-08-23 15:49 GMT+04:00 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> On Sat, Aug 23, 2014 at 12:16:01PM +0400, Pavel Shilovsky wrote:
>> These are two patches that adds CIFS support to XFS tests.
>>
>> The first patch adds "-cifs" command line argument and CIFS specific variables. The second patch setups a directory tree for possible CIFS specific tests.
>>
>> With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.
>
> That's against an smb1 server with posix extentions?  don't you need
> various new _require_foo checks for things not support on normal
> SMB1/2/3?

It was tested in posix and non-posix modes.The difference is in tests
005, 023, 024, 131 that are fail on non-posix.

We can add _require_posix() that checks if the mounted filesystem is
cifs and nounix (for example through cat /proc/mounts | grep $TEST_DEV
| grep cifs | grep nounix) and disable the above tests for this case.

-- 
Best regards,
Pavel Shilovsky.
