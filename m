From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs] cifs: Allow binding to local IP address.
Date: Wed, 25 Aug 2010 19:35:34 -0500
Message-ID: <AANLkTi=m800LPdE47tiPGPT3qfQG7YXC0Q6nh+EXhnx=@mail.gmail.com>
References: <1282777235-20218-1-git-send-email-greearb@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282777235-20218-1-git-send-email-greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 25, 2010 at 6:00 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> w=
rote:
> When using multi-homed machines, it's nice to be able to specify
> the local IP to use for outbound connections. =A0This patch gives
> cifs the ability to bind to a particular IP address.
>
> Usage: =A0mount -t cifs -o bindaddr=3D192.168.1.50,user=3Dfoo, ...

Seems like a reasonable idea, but I have a few questions.
Is there a similar named mount option for other network
file systems on other operating systems?

Also don't IPv6 address strings already allow you to specify the local
interface to use?

--=20
Thanks,

Steve
