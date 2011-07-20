From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cifs: fix cast on cifs_demultiplex_thread
Date: Wed, 20 Jul 2011 16:19:50 +0100
Message-ID: <20110720151950.GY11013@ZenIV.linux.org.uk>
References: <1310393863-12531-1-git-send-email-jlayton@redhat.com>
 <1311174566-7172-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1311174566-7172-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 20, 2011 at 11:09:26AM -0400, Jeff Layton wrote:
> My initial pass at doing this just eliminated the cast altogether. When
> I played with it today though, that caused a compiler warning. So, just
> fix the cast instead.

See 7c97c200e2c5aa8b1067bebb99df0a7c2e12ebf3 in vfs-2.6.git...
