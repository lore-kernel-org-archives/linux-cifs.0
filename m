From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: move "ntlmssp" and "local_leases" options out
 of experimental code
Date: Fri, 17 Dec 2010 20:58:56 +0530
Message-ID: <4D0B81B8.6090603@suse.de>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com> <1291820625-20907-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291820625-20907-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/08/2010 08:33 PM, Jeff Layton wrote:
> I see no real need to leave these sorts of options under an
> EXPERIMENTAL ifdef. Since you need a mount option to turn this code
> on, that only blows out the testing matrix.
> 
> local_leases has been under the EXPERIMENTAL tag for some time, but
> it's only the mount option that's under this label. Move it out
> from under this tag.
> 
> The NTLMSSP code is also under EXPERIMENTAL, but it needs a mount
> option to turn it on, and in the future any distro will reasonably
> want this enabled. Go ahead and move it out from under the
> EXPERIMENTAL tag.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |    5 +--
>  fs/cifs/connect.c |    4 --
>  fs/cifs/sess.c    |  103 ++++++++++++++++++++++++-----------------------------
>  3 files changed, 48 insertions(+), 64 deletions(-)

Moving local_leases out sounds fine to me. While I agree that NTLMSSP is
something everyone wants moving ahead, I'm not sure whether there are
currently any known/open issues with specific Servers.
Shirish?

Assuming there are none,

Acked-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
