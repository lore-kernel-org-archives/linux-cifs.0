From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: manpage: update mount.cifs manpage with info about
 echo_interval option.
Date: Wed, 24 Jan 2018 16:23:03 +0530
Message-ID: <1516791183.20341.2.camel@redhat.com>
References: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g@mail.gmail.com>
         <87y3knsfpa.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87y3knsfpa.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2018-01-24 at 11:40 +0100, Aurélien Aptel wrote:
> In practice I've noticed that we actually wait for twice the
> echo_interval value to reconnect (/me has been doing a lot of
> reconnection tests lately).
> 
> Cheers,
> 
I've documented it at
http://sprabhu.blogspot.in/2015/08/investigation-into-effects-of-server
.html
if you are interested.

Upstream patch which added this option.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm
it/?id=adfeb3e00e8e1b9fb4ad19eb7367e7c272d16003
