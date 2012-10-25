From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS: Move readpage code to ops struct
Date: Thu, 25 Oct 2012 09:50:32 -0400
Message-ID: <20121025095032.4cad08db@corrin.poochiereds.net>
References: <20121025112820.GA5802@elgon.mountain>
	<CAKywueQY9bRT08ZPXXoRTVNqtwfMRu5WxZb2vacFLB1AkJ3K=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQY9bRT08ZPXXoRTVNqtwfMRu5WxZb2vacFLB1AkJ3K=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Oct 2012 17:34:38 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 2012/10/25 Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
> > Hello Pavel Shilovsky,
> >
> > This is a semi-automatic email about new static checker warnings.
> >
> > The patch f9c6e234c3ca: "CIFS: Move readpage code to ops struct" from
> > Sep 18, 2012, leads to the following Smatch complaint:
> >
> > fs/cifs/file.c:2954 cifs_read()
> >          warn: variable dereferenced before check 'tcon->ses' (see line 2932)
> >
> > fs/cifs/file.c
> >   2931          tcon = tlink_tcon(open_file->tlink);
> >   2932          server = tcon->ses->server;
> >                          ^^^^^^^^^^^
> > New dereference.
> >
> >   2933
> >   2934          if (!server->ops->sync_read) {
> >   2935                  free_xid(xid);
> >   2936                  return -ENOSYS;
> >   2937          }
> >   2938
> >   2939          if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> >   2940                  pid = open_file->pid;
> >   2941          else
> >   2942                  pid = current->tgid;
> >   2943
> >   2944          if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> >   2945                  cFYI(1, "attempting read on write only file instance");
> >   2946
> >   2947          for (total_read = 0, cur_offset = read_data; read_size > total_read;
> >   2948               total_read += bytes_read, cur_offset += bytes_read) {
> >   2949                  current_read_size = min_t(uint, read_size - total_read, rsize);
> >   2950                  /*
> >   2951                   * For windows me and 9x we do not want to request more than it
> >   2952                   * negotiated since it will refuse the read then.
> >   2953                   */
> >   2954                  if ((tcon->ses) && !(tcon->ses->capabilities &
> >                              ^^^^^^^^^
> > Old check.
> >
> >   2955                                  tcon->ses->server->vals->cap_large_files)) {
> 
> I don't think that tcon->ses can be NULL here - it seems that we can
> remove this check. Thoughts?
> 

Agreed. I think that this is a holdover from some really old code
before we fixed up all the refcounting and object lifetime. The tcon
should be holding a reference to its session object, which in turn
holds a reference to the server object. If tcon->ses is NULL then
something is very, very wrong. I believe you can just remove that check.


> >   2956                          current_read_size = min_t(uint, current_read_size,
> >
> > regards,
> > dan carpenter
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
