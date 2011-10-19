From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: async read patchset test results
Date: Wed, 19 Oct 2011 13:57:55 +0400
Message-ID: <CAKywueTGPOU=ej18tH8SO-7=r5E-BjpUkax1aMrQhoWDZJNyxA@mail.gmail.com>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
	<20111013140039.3200de5d@barsoom.rdu.redhat.com>
	<CAKywueSfX7sn46uPTz2L3WWWZgpNmEfECJDv70Lr-jjFvTXi+g@mail.gmail.com>
	<CAKywueQ20Jh139J4E0XfJ+ZTPsO8gDpXPHL2jZ3YBh72ajKAWA@mail.gmail.com>
	<20111014065508.2f4735d3@tlielax.poochiereds.net>
	<CAKywueT3d0dEf__rsoFZ1VK3s72CLXJjFQyGqDdTEe=6-hH-Yw@mail.gmail.com>
	<CAH2r5muvh_6K_Ou4Jz3Qwu6GNRn9ZJwQ5wLw71g=OfZwj+HVNQ@mail.gmail.com>
	<CAKywueQ2BAUYj-DKp3=H_t5ySTS=AgiY40t=_9rXw1hD-4MaxQ@mail.gmail.com>
	<CAH2r5mtAgsJx_uuaEVstysGimS5zs8QxG6dgne4eDmbSyY2A+Q@mail.gmail.com>
	<CAKywueTeDMugdyZ1qkN_R1G-RPGcLaGmTCFyDqLPWXYSR5W7mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTeDMugdyZ1qkN_R1G-RPGcLaGmTCFyDqLPWXYSR5W7mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/19 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/10/19 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> If the session could continue after an incorrect checksum (ie retry
>> the operation
>> that failed due to the network error/corruption)
>> then there would be significant advantage in not taking the session down.
>> In practice would that request time out and get killed and retried?
>
> As cifs_check_receive doesn't return any error if checksum doesn't
> match the original, readpages continues the read-ahead process and
> nothing else happens (I mean the request isn't time out, get killed
> and retried).
>
> So, if we don't kill the session in this case, we can simply return
> -EAGAIN and let the calling routine retry the operation itself.
> Thoughts?

I tried this patch and it works good to me:

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 33a3fbf..b54a631 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -508,8 +508,10 @@ cifs_check_receive(struct mid_q_entry *mid,
struct TCP_Server_Info *server,
                iov.iov_len = len;
                /* FIXME: add code to kill session */
                if (cifs_verify_signature(&iov, 1, server,
-                                         mid->sequence_number + 1) != 0)
+                                         mid->sequence_number + 1) != 0) {
                        cERROR(1, "Unexpected SMB signature");
+                       return -EAGAIN;
+               }
        }

        /* BB special case reconnect tid and uid here? */


I also applied almost the same patch (that includes the fix for
cifs_readv_callback) to Jeff's async read patchset , fixed the
problems with the error handling in cifs_readv_complete (I posted them
to the list) and got the same good result.

-- 
Best regards,
Pavel Shilovsky.
