From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cifs: skip tests that need POSIX support for
 nounix mounts
Date: Wed, 27 Aug 2014 08:58:32 -0700
Message-ID: <20140827155832.GA3103@infradead.org>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
 <1409084918-17764-4-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409084918-17764-4-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 27, 2014 at 12:28:38AM +0400, Pavel Shilovsky wrote:
> CIFS/SMB protocol without POSIX extensions doesn't support operations
> with symbolic links and advisory byte-range locks from the same process.
> Add a check for nounix mounts and use it in generic tests that
> require such operations.

+_require_test_posix_ext seems very cifs specific.  Can you take
a look at the tests and see what posix feature they require and
add features based on that?  Let's have a quick discussion here on the
requirements of the tests before even writing the code.

> diff --git a/tests/generic/005 b/tests/generic/005
> index d78e43f..0c2b51f 100755
> --- a/tests/generic/005
> +++ b/tests/generic/005
> @@ -67,6 +67,7 @@ _touch()
>  # real QA test starts here
>  _supported_fs generic
>  _require_test
> +_require_test_posix_ext
>  
>  # IRIX UDF does not support symlinks
>  if [ $FSTYP == 'udf' ]; then

this suggest 005 needs symlinks and plain cifs doesn't support them.
We should also fold this test for IRIX udf into the _requires_symlink
tests.

> diff --git a/tests/generic/023 b/tests/generic/023
> index 114485c..91b8a37 100755
> --- a/tests/generic/023
> +++ b/tests/generic/023
> @@ -45,6 +45,7 @@ _supported_os Linux
>  
>  _require_test
>  _requires_renameat2
> +_require_test_posix_ext


023-025 just require a working renameat2, and nothing in Posix.  What's
the problem for cifs here?

> diff --git a/tests/generic/131 b/tests/generic/131
> index b4e3ff0..9736963 100755
> --- a/tests/generic/131
> +++ b/tests/generic/131
> @@ -45,6 +45,7 @@ _cleanup()
>  _supported_fs generic
>  _supported_os Linux
>  _require_test
> +_require_test_posix_ext
>  
>  TESTFILE=$TEST_DIR/lock_file

131 tests fcntl style file locking, so we should test for that.
