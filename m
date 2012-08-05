From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ubuntu SecurityFlags at boot
Date: Sun, 5 Aug 2012 10:29:39 -0500
Message-ID: <CAH2r5mvHpv5mFGNyq7gheMkMuXHqKWeSLaVTnwZtVam65hfHvw@mail.gmail.com>
References: <S1753625Ab2HELY7/20120805112459Z+242@vger.kernel.org>
	<484724139.8236317.1344166282900.JavaMail.root@zimbra76-e14.priv.proxad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: blueduck-GANU6spQydw@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <484724139.8236317.1344166282900.JavaMail.root-TwAYtqM7ZI5mpWzFTGZ+Dhh1pbbyJDp15NbjCUgZEJk@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It would be possible to build cifs.ko to enable plain text passwords
permanently, but may be simpler to just set this in one of the init
scripts.  Generally we want to discourage anyone from using
authentication types other than ntlmv2 and kerberos for obvious
security reasons.

On Sun, Aug 5, 2012 at 6:31 AM,  <blueduck-GANU6spQydw@public.gmane.org> wrote:
> Hi,
>
> Looking at fs/cifs/README, I managed to mount shares with plaintext passwords (using Kubuntu 12.04) with "echo 0x30030 > /proc/fs/cifs/SecurityFlags". But it as to be done after each boot.
>
> Is there any configuration file to modify to make the change permanent?
>
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
