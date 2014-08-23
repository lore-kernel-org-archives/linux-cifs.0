From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] common: add cifs support
Date: Sat, 23 Aug 2014 04:56:06 -0700
Message-ID: <20140823115606.GA29808@infradead.org>
References: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
 <1408781763-30127-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408781763-30127-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Aug 23, 2014 at 12:16:02PM +0400, Pavel Shilovsky wrote:
> Pass -cifs argument from command line to enable cifs testing.

Looks mostly fine, but a few nitpicks below:

>  _mount_opts()
>  {
> +
>  	case $FSTYP in

Remove this spurious new empty line, please.

> -	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
> +	echo $TEST_DEV | grep -qE ":|//" > /dev/null 2>&1
>  	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
> -		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
> +		echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS or CIFS filesystem"
>  		exit 1
>  	fi

I'd just generalize this to ".. is not a block device or network
filesystem"

> -	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> +	echo $SCRATCH_DEV | grep -qE ":|//" > /dev/null 2>&1
>  	if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
> -		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
> +		echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS or CIFS filesystem"
>  		exit 1
>  	fi

Same here.

>  
>  # make sure we have a standard umask
> @@ -148,6 +150,11 @@ _test_options()
>      type=$1
>      TEST_OPTIONS=""
>  
> +    if [ "$FSTYP" = "cifs" ]; then
> +        TEST_OPTIONS="$MOUNT_OPTIONS"
> +        return
> +    fi

What's this for?  This doesn't really make sense to me as this function adds
mkfs/mount options to the already normally specified ones.

> +	cifs)
> +		echo $TEST_DEV | grep -q "//" > /dev/null 2>&1
> +		if [ -z "$TEST_DEV" -o "$?" != "0" ];
> +		then
> +			_notrun "this test requires a valid \$TEST_DEV"
> +		fi
> +		if [ ! -d "$TEST_DIR" ];
> +		then
> +		     _notrun "this test requires a valid \$TEST_DIR"
> +		fi
> +		;;

Please put the then on the same line as the if for new code.

> diff --git a/tests/generic/013 b/tests/generic/013
> index 93d9904..ae57c67 100755
> --- a/tests/generic/013
> +++ b/tests/generic/013
> @@ -35,7 +35,12 @@ _cleanup()
>  {
>      cd /
>      # we might get here with a RO FS
> -    mount -o remount,rw $TEST_DEV >/dev/null 2>&1
> +    REMOUNT_OPTIONS="remount,rw"
> +    if [ "$FSTYP" = "cifs" ];
> +    then
> +        REMOUNT_OPTIONS="$REMOUNT_OPTIONS,$MOUNT_OPTIONS"
> +    fi
> +    mount -o $REMOUNT_OPTIONS $TEST_DEV >/dev/null 2>&1

This looks wrong and will need an explanation.
