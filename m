From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cifs: skip tests that need POSIX support for
 nounix mounts
Date: Wed, 27 Aug 2014 11:17:25 -0500
Message-ID: <CAH2r5mtOF3HgsDiuZSTfu62p8do35S6a9Sy74bVOAD9CXphVQQ@mail.gmail.com>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
 <1409084918-17764-4-git-send-email-pshilovsky@samba.org> <20140827155832.GA3103@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140827155832.GA3103-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 27, 2014 at 10:58 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Wed, Aug 27, 2014 at 12:28:38AM +0400, Pavel Shilovsky wrote:
>> CIFS/SMB protocol without POSIX extensions doesn't support operations
>> with symbolic links and advisory byte-range locks from the same process.
>> Add a check for nounix mounts and use it in generic tests that
>> require such operations.
>
> +_require_test_posix_ext seems very cifs specific.  Can you take
> a look at the tests and see what posix feature they require and
> add features based on that?  Let's have a quick discussion here on the
> requirements of the tests before even writing the code.

Do you know a more standardized way to test if symlink support is available?
We don't really have the same thing as the FS and Device capability ioctls
that Microsoft offers, but even for them, they don't export whether symlink
support is enabled as a volume or export property.
Presumably we could try to create one and look for the rc EOPNOTSUPP), but
it seems simple enough for now to check on mount looking for
fs-specific features
as Pavel has done, or to always enable the symlink tests for cifs (and
smb3 after
we have added it).




>
> this suggest 005 needs symlinks and plain cifs doesn't support them.
> We should also fold this test for IRIX udf into the _requires_symlink
> tests.

Plain cifs does support emulated symlinks two ways but they aren't enabled by
default in mount.  At least one of these also needs to be added to SMB3, and
when I looked at this in the past it looked fairly easy. When support for
"mfsymlinks" (apple-style emulated symlinks) or for creating "NFS-reparse point
symlinks" (Windows style NFS server symlinks)  is added
for SMB3 we could change the way the cifs check is done.  In the long run I
would prefer that we run the cifs and smb3 xfstest runs with symlink
dependent tests enabled.

>> diff --git a/tests/generic/023 b/tests/generic/023
>> index 114485c..91b8a37 100755
>> --- a/tests/generic/023
>> +++ b/tests/generic/023
>> @@ -45,6 +45,7 @@ _supported_os Linux
>>
>>  _require_test
>>  _requires_renameat2
>> +_require_test_posix_ext
>
>
> 023-025 just require a working renameat2, and nothing in Posix.  What's
> the problem for cifs here?




-- 
Thanks,

Steve
