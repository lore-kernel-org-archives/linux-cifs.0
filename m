From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
Date: Mon, 15 Aug 2011 06:54:29 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110815064734.403b630f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On Mon, 15 Aug 2011, Jeff Layton wrote:

> On Mon, 15 Aug 2011 11:18:38 +0200 (CEST)
> Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> wrote:
>
> There was at least one known oops at mount time with 3.0:
>
>    https://bugzilla.redhat.com/show_bug.cgi?id=727927
>
> ...but I can't tell whether you hit that w/o seeing the oops messasge.
>
> It should be fixed in mainline and the patches for that and another
> mount time problem will be in the next set of stable kernels. You may
> want to pull these two commits into your kernel and try again:
>
> 80975d21aae2136ccae1ce914a1602dc1d8b0795
> f9e8c45002cacad536b338dfa9e910e341a49c31
>

Thanks,

Patches applied to 3.0.1 and will try to mount the CIFS shares later today:

# patch -p1 < /home/war/cifs1
patching file fs/cifs/cifsfs.c
# patch -p1 < /home/war/cifs2
patching file fs/cifs/inode.c

Justin.
