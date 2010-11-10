From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: Re: [PATCH] cifs: fix another memleak, in cifs_root_iget
Date: Wed, 10 Nov 2010 22:59:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011102257400.11302@swampdragon.chaosbits.net>
References: <1289423173-7044-1-git-send-email-oskar@scara.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Oskar Schirmer <oskar-fYPSZ7JpQqsAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289423173-7044-1-git-send-email-oskar-fYPSZ7JpQqsAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 10 Nov 2010, Oskar Schirmer wrote:

> cifs_root_iget allocates full_path through
> cifs_build_path_to_root, but fails to kfree it upon
> cifs_get_inode_info* failure.
> 
> Make all failure exit paths traverse clean up
> handling at the end of the function.
> 
> Signed-off-by: Oskar Schirmer <oskar-fYPSZ7JpQqsAvxtiuMwx3w@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

I've reviewed your patch (although not actually tested it) and your 
changes look sane.
So, feel free to add

Reviewed-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
