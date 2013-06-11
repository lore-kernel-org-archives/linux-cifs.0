From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/19] cifs: overhaul of auth selection code
Date: Mon, 10 Jun 2013 20:23:45 -0400
Message-ID: <20130610202345.5e28598d@corrin.poochiereds.net>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtjbKmywi_qDoF95avACkumXCSvdtSYK8yo0sKp2X=AhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtjbKmywi_qDoF95avACkumXCSvdtSYK8yo0sKp2X=AhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 10 Jun 2013 17:28:05 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff,
> I reviewed and merged (into for-next of cifs-2.6.git) more from this
> series (patches 9 through 15, taking the version from the cifs-3.11
> branch of your git tree on samba.org).   Made trivial change to patch
> 15 (fixed a comment which caused a line over 80 columns).
> 
> Will continue reviewing
> 

Thanks for doing this. Should be only one more tough one to review
(#16). The last three are pretty straightforward.

> Hopefully Shirish can rebase his SMB3 signing work on top of this.
> 

>From what I can tell, his preliminary patch looked fairly orthogonal to
this set. If not, then it's my hope that this set will make it easier
to implement SMB3 signing properly.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
