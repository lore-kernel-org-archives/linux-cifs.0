From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/2] common: add cifs support
Date: Mon, 25 Aug 2014 10:56:18 +1000
Message-ID: <20140825005618.GV26465@dastard>
References: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
 <1408781763-30127-2-git-send-email-pshilovsky@samba.org>
 <20140823115606.GA29808@infradead.org>
 <CAKywueS=X4fyVYhy8_LGzwN5YO=E5Z8rS7MGG-fS8_GQ86LdOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueS=X4fyVYhy8_LGzwN5YO=E5Z8rS7MGG-fS8_GQ86LdOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 24, 2014 at 11:54:50AM +0400, Pavel Shilovsky wrote:
> 2014-08-23 15:56 GMT+04:00 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> > On Sat, Aug 23, 2014 at 12:16:02PM +0400, Pavel Shilovsky wrote:
> >> Pass -cifs argument from command line to enable cifs testing.
> >
> > Looks mostly fine, but a few nitpicks below:
....
> >>
> >> +    if [ "$FSTYP" = "cifs" ]; then
> >> +        TEST_OPTIONS="$MOUNT_OPTIONS"
> >> +        return
> >> +    fi
> >
> > What's this for?  This doesn't really make sense to me as this function adds
> > mkfs/mount options to the already normally specified ones.
> 
> 1) We included common/rc -- init_rc() is called.
> 2) init_rc() checks if $TEST_DEV is mounted and if not -- calls _test_mount().
> 3) _test_mount() calls _test_options() that:
>   a) initializes TEST_OPTIONS=''
>   b) adds rtdev,logdev options to TEST_OPTIONS for XFS; for others
> filesystems it simply returns leaving TEST_OPTIONS as empty string.
> 
> That's why we need to initialize TEST_OPTIONS as MOUN_OPTIONS for CIFS
> because we can't mount a remote share without specifying a username,
> password, etc.

That is what $TEST_FS_MOUNT_OPTS is supposed to be for. Make that
work properly when specified on the CLI or via the config file
just like MOUNT_OPTIONS does for the scratch device.

> >>      cd /
> >>      # we might get here with a RO FS
> >> -    mount -o remount,rw $TEST_DEV >/dev/null 2>&1
> >> +    REMOUNT_OPTIONS="remount,rw"
> >> +    if [ "$FSTYP" = "cifs" ];
> >> +    then
> >> +        REMOUNT_OPTIONS="$REMOUNT_OPTIONS,$MOUNT_OPTIONS"
> >> +    fi
> >> +    mount -o $REMOUNT_OPTIONS $TEST_DEV >/dev/null 2>&1
> >
> > This looks wrong and will need an explanation.
> 
> We can't remount the existing CIFS mount without specifying username
> and password. Also we need to keep others options as well since they
> are user-defined (e.g. nounix, noserverino, etc) while during
> remounting mount options are changed to the specified ones.

filesystem configuration details like this should not pollute the
test code. Write a helper similar to _scratch_remount():

_test_remount()
{
	$UNMOUNT_PROG $TEST_DIR
	_test_mount
}

and use that in the test instead.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
