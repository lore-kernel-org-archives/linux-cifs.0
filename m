From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix race condition on RFC1002_NEGATIVE_SESSION_RESPONSE
Date: Wed, 20 May 2015 13:26:24 -0500
Message-ID: <CAH2r5ms3ULF0GnBNPzf5T8HyYHprezn4EAGg0aXkk55zSGH2aA@mail.gmail.com>
References: <550860D2.5040207@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550860D2.5040207-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Tue, Mar 17, 2015 at 12:13 PM, Federico Sauter
<fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org> wrote:
> Greetings,
>
>
> I have been running into an issue (kernel v3.10.40) when connecting to an NT
> 3.51 Workstation host with a configuration missing the NetBIOS name
> ('servern' option.) Under some conditions, the mount helper would hang
> forever in an uninterruptible sleep state. The mount helper comes from
> busybox. Under some other conditions the mount program would exit with an
> error and not hang.
>
> I managed to create a setup where I could reliably reproduce both cases (the
> "good case" where the program exits, and the "bad case" where the program
> hangs forever.)
>
> The problem seems to be a race condition between the demux thread and the
> "main"(?) thread over the srv_mutex. Here is the summary of the functions
> calls that lead to this problem:
>
> * demux thread:
> cifs_demultiplex_thread()
>   is_smb_response()
>     [connect.c:626 -- case RFC1002_NEGATIVE_SESSION_RESPONSE]
>       cifs_reconnect()
>         [connect.c:380]
>         do {
>           mutex_lock(&server->srv_mutex);
>           generic_ip_connect(server);
>           // on error -> msleep(3000);
>           mutex_unlock(&server->srv_mutex);
>         } while (server->tcpStatus == CifsNeedReconnect);
>
> * "main" thread:
> cifs_negotiate()
>   CIFSSMBNegotiate()
>     SendReceive()
>       [transport.c:821 - thread hangs forever]
>       mutex_lock(&ses->server->srv_mutex);
>
> Another interesting piece of information is that in the good case at
> cifs_reconnect(), generic_ip_connect() returns -EINTR, whereas in the bad
> case it returns -ECONNREFUSED. In the bad case it all leads to
> generic_ip_connect() being called over and over again with the same result,
> but never exiting the loop (thus: hanging.)
>
> The following patch works around the issue by not re-attempting the SMB
> negotiation:
>
> ---8<----------------------------------------------------------------------
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 4885a40..863a2da 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -415,10 +415,12 @@ cifs_negotiate(const unsigned int xid, struct cifs_ses
> *ses)
>         int rc;
>         rc = CIFSSMBNegotiate(xid, ses);
>         if (rc == -EAGAIN) {
> +#if 0
>                 /* retry only once on 1st time connection */
>                 set_credits(ses->server, 1);
>                 rc = CIFSSMBNegotiate(xid, ses);
>                 if (rc == -EAGAIN)
> +#endif
>                         rc = -EHOSTDOWN;
>         }
>         return rc;
> ---------------------------------------------------------------------->8---
>
> I was able, however, to identify a (hopefully) better solution for the issue
> (see the attached patch.)
>
> I would really appreciate your feedback on the attached patch. Please let me
> know if the solution seems acceptable as well as side-effects-free. We use
> CIFS to connect to older Windows systems and we have been experiencing
> similar issues for a while now (which I hope to solve with this patch.)
>
> Thanks a lot in advance! :-)
>
>
> Kind regards,
>
>
> Federico Sauter
> Senior Firmware Programmer
> --
> Innominate Security Technologies AG
> Rudower Chaussee 13 | 12489 Berlin | Germany
> tel: +49 30 921028-210 | fax: +49 30 921028-020
> www.innominate.com | www.twitter.com/mGuardcom
>
> Register Court: AG Charlottenburg, HR B 81603
> Management Board: Dirk Seewald | Chairman of the Supervisory Board:
> Christoph Leifer



-- 
Thanks,

Steve
