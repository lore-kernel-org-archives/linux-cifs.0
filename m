From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 13/15] cifs: convert cifsFileInfo->count to non-atomic
 counter
Date: Thu, 7 Oct 2010 13:42:15 -0400
Message-ID: <20101007134215.4aeadda9@corrin.poochiereds.net>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
	<1286394857-32541-14-git-send-email-jlayton@redhat.com>
	<4CAD8972.9090406@suse.de>
	<20101007071819.2446312b@barsoom.rdu.redhat.com>
	<4CADB949.2070205@suse.de>
	<20101007084334.0e03f586@barsoom.rdu.redhat.com>
	<AANLkTi=MMzU6nr6+19PKW=gPKTdk9e-O5pjrYWmbV4AJ@mail.gmail.com>
	<20101007125932.4506f3e6@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007125932.4506f3e6-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 7 Oct 2010 12:59:32 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> For instance:
> 
> +	if (!atomic_dec_and_lock(&cifs_file->count, &cifs_file_list_lock))
> +		return;
> +
> +	/* count can be incremented inside the lock, so must check again */
> +	if (atomic_read(&cifs_file->count) > 0) {
> +		spin_unlock(&cifs_file_list_lock);
> +		return;
> +	}
> 

...oh and to make matters worse, the above code is still racy if the
count can be incremented outside the lock too.

I think we need to try to keep this code as simple as possible with
clear, unambiguous locking rules around a simple counter.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
