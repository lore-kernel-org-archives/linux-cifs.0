From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/8] cifs: add CIFSCheckMFSymlink() as stub
Date: Mon, 09 Aug 2010 19:46:11 +0530
Message-ID: <4C600DAB.1060903@suse.de>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>	<1280931109-22380-4-git-send-email-metze@samba.org>	<20100804103748.521163e6@tlielax.poochiereds.net>	<4C5AAA3C.1000304@suse.de> <20100805083113.2e7bfbb9@barsoom.rdu.redhat.com> <4C600AEA.607@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C600AEA.607-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/09/2010 07:34 PM, Stefan (metze) Metzmacher wrote:
> Hi,
> 
> I noticed that I also need to hook the cifs_readdir() path.
> 
> Can someone tell me how I can construct the file name
> relative to the mount point. The TODO in this change.

build_path_from_dentry() ?


-- 
Suresh Jayaraman
