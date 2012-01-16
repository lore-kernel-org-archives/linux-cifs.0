From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Properly update mtab during remount V5
Date: Mon, 16 Jan 2012 12:38:20 -0500
Message-ID: <20120116123820.3b16709f@tlielax.poochiereds.net>
References: <1326369090-11600-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326369090-11600-1-git-send-email-cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 12 Jan 2012 09:51:30 -0200
Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> During a remount of a cifs filesystem, the mtab file is not properly updated,
> which leads to a doubled entry of the same filesystem in the /etc/mtab file.
> This patch adds a new function del_mtab() which is called before the add_mtab()
> in case the fs is being remounted.
> The del_mtab() function will delete from the mtab, the old entry from the
> filesystem which is being remounted, and then, calls add_mtab() to add an
> updated entry to the mtab file.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mount.cifs.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 99 insertions(+), 1 deletions(-)
> 


Merged, but I also just sent a follow-on patch for this code as well...

--
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
