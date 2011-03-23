From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Tue, 22 Mar 2011 22:34:59 -0500
Message-ID: <AANLkTimBdrWfAXZ4Ea_K33PyFN_REfNwcH7JjW71mJnh@mail.gmail.com>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
	<20110322080409.23461155@corrin.poochiereds.net>
	<AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
	<20110322111711.55365655@corrin.poochiereds.net>
	<AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw@mail.gmail.com>
	<20110322123549.022e590e@corrin.poochiereds.net>
	<AANLkTim=J7Y-b07HHKypfxgXL=jpgVVaZ1hn2201Amny@mail.gmail.com>
	<AANLkTikg4WQrguR_cvvkxXZ8XomO=3ySjPzT67yO_cvk@mail.gmail.com>
	<20110322130334.0680b9a3@corrin.poochiereds.net>
	<AANLkTikSUaLsEk5CNfVMXqLN4z=UGOeyYoMkTGQBLf2A@mail.gmail.com>
	<20110322134246.4b9e497e@corrin.poochiereds.net>
	<AANLkTi=zcYODYnx1q1bzBQtt2z7w1rkRxSTNTrK4u=7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=zcYODYnx1q1bzBQtt2z7w1rkRxSTNTrK4u=7d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,
Jeff and I talked about invalidate_mapping and its uses this
afternoon.  A few comments:
1)   Take a look at what happens on filemap_fdatawait call in
invalidate_mapping to see if it makes sense to return errors through
back to some of the callers of invalidate_mapping, in particular,
strict_fsync.  If we can't write out the file data (ENOSPC, or host
down etc.), we want to make sure that the return code gets sent back
on any calls that can reasonably expect such an error.
2) If invalidate_inode_pages2 fails (e.g. with EBUSY, because one of
the pages couldn't be freed from the mapping because it just got
redirtied right after we flushed it the line before) we set the
mapping to invalid but don't check
    cifs_i->invalid_mapping
in many places.  Should we add checks for cifs_i->invalid_mapping in
more places?
3)   The error message below in invalidate_mapping (on EBUSY) should
be removed or changed to an cFYI:
           cERROR(1, "%s: could not invalidate inode %p", __func__, inode);




-- 
Thanks,

Steve
