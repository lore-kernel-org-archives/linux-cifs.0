From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 10/14] cifs: convert GlobalSMBSeslock from a rwlock to
 regular spinlock
Date: Tue, 05 Oct 2010 16:00:29 +0530
Message-ID: <4CAAFE45.6070803@suse.de>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com> <1286214781-626-11-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-11-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/04/2010 11:22 PM, Jeff Layton wrote:
> To prevent races we need to be able to do an atomic_dec_and_lock with
> it, and that won't work with a rwlock.

It's not clear to me where a potential race window is. Could you please
elaborate?


Thanks,

-- 
Suresh Jayaraman
