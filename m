From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 6/6] CIFS: Add strictcache mount option
Date: Thu, 18 Nov 2010 22:58:45 +0530
Message-ID: <4CE5624D.9010109@suse.de>
References: <1289403711-12965-1-git-send-email-piastryyy@gmail.com> <1289403711-12965-7-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289403711-12965-7-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/10/2010 09:11 PM, Pavel Shilovsky wrote:
> Use for switching on strict cache mode. In this mode the
> client read from the cache all the time it has Oplock Level II,
> otherwise - read from the server. All written data are stored
> in the cache, but if the client doesn't have Exclusive Oplock,
> it writes the data to the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/README    |    5 +++++
>  fs/cifs/connect.c |    5 +++++
>  2 files changed, 10 insertions(+), 0 deletions(-)


Sorry for chiming in so late. IIUC, the name 'strictcache' was chosen to
mean "strictly use cache" as in "strict sync" option in smb.conf. But,
I'm afraid that the name also make users think of strict cache coherency
which is a different behavior. Is there a alternative name that you
could think of to avoid confusion?


-- 
Suresh Jayaraman
