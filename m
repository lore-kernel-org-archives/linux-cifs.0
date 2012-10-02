From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Ubuntu SecurityFlags at boot
Date: Tue, 2 Oct 2012 07:19:54 -0400
Message-ID: <20121002071954.51333f41@tlielax.poochiereds.net>
References: <506A17EB.2050908@appcomsci.com>
	<20121001214848.45781bb3@corrin.poochiereds.net>
	<506A7AA9.2090606@appcomsci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506A7AA9.2090606-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 02 Oct 2012 01:24:57 -0400
"Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org> wrote:

> Thank you so much for explaining what should have been utterly obvious. 
>   It worked perfectly when I did this:
> 
> % sudo -i
> # echo 0x30030 > /proc/fs/cifs/SecurityFlags
> # mount -t cifs //myoldtiredserver/lott /mnt
> 
> I'm still getting used to using echo for communicating with a kernel 
> module but that's just gonna take time :)
> 
> On 10/01/2012 09:48 PM, Jeff Layton wrote:
> > The sudo in the above command just covers the echo command. The shell
> > redirection (and hence the write to SecurityFlags) is done as the
> > original user, which is why you're getting EACCES. You probably want
> > to do something like this to ensure that the shell redirection is done
> > as root as well:
> >
> >      $ sudo sh -c "echo 0x30030 > /proc/fs/cifs/SecurityFlags"
> >
> 

No problem, shell redirection is tricky and not always obvious...

If someone asked me to invent the most unintuitive, obfuscated
interface possible for setting up cifs.ko authentication, I'd be
hard-pressed to improve on SecurityFlags. Personally, I'd like to see
that go the way of the dodo.

We ought to have a sane, fixed heuristic that decides what
authentication to use based on the NEGOTIATE_PROTOCOL exchange with the
server. Then, we could just allow people to override that by setting a
sec= mount option.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
