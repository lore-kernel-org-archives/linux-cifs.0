From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4][cifs-utils] Improvement and fixes for command line
 options
Date: Fri, 18 Nov 2016 15:50:32 -0500
Message-ID: <1479502232.5248.4.camel@samba.org>
References: <1479495292-709-1-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479495292-709-1-git-send-email-germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2016-11-18 at 18:54 +0000, Germano Percossi wrote:
> The way command line parsing for mount is done, is not aligned with the
> corresponding kernel module.
> 
> Options checking is not strict, some options the cifs module accepts
> are not honoured, others are accepted (and converted) even though
> they are not documented nor otherwise accepted in the cifs module.
> 
> Moreover, it is not possible to send an empty domain without receiving an
> error, while the cifs module treats the 2 cases slightly differently.
> 
> The other 2 patches are trivial
> 
> Germano Percossi (4):
>   [cifs-utils] Removed extra comma in front of domain
>   [cifs-utils] Accept empty domains on the command line
>   [cifs-utils] Fixed command line parsing and aligned with kernel
>   [cifs-utils] Remove unneeded stdbool header in mount.cifs
> 
>  mount.cifs.c | 100 +++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 60 insertions(+), 40 deletions(-)
> 

Thanks. Patches 1, 3 and 4 look fine. I'm not quite sold yet on #2
though since I'm a little unclear on when you'd want to do either.

Either way, it would also be nice to flesh out the domain= section of
the mount.cifs manpage as well. It's a little thin...

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
