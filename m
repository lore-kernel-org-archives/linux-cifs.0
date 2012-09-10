From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add support of Alternate Data Streams
Date: Mon, 10 Sep 2012 13:11:51 -0400
Message-ID: <CAFB9KM24fUwwK6e3A8Bn2S6R+oc8FkgDz+acE1ndZW3EW1CudA@mail.gmail.com>
References: <1346713566-31140-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120905101120.5b6a7a01@tlielax.poochiereds.net>
	<CADT32eLKyA2nfKWsnuvWbyDeSHqdeXZ-J4RYQ4t-VsBf6cPFfg@mail.gmail.com>
	<20120910082317.792b424b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120910082317.792b424b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>> > > @@ -351,12 +351,17 @@ int cifs_get_inode_info_unix(struct inode **pinode,
>> > >                       cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
>> > >       }
>> > >
>> > > +     if (strstr(full_path, ":"))
>> > > +             fattr.cf_flags |= S_PRIVATE;
>> > > +
>> > >       if (*pinode == NULL) {
>> > >               /* get new inode */
>> > >               cifs_fill_uniqueid(sb, &fattr);
>> > >               *pinode = cifs_iget(sb, &fattr);
>> > >               if (!*pinode)
>> > >                       rc = -ENOMEM;
>> > > +             if (strstr(full_path, ":"))
>> > > +                     (*pinode)->i_flags |= S_PRIVATE;

^ On -ENOMEM you dereference a null pointer, don't you?  Same thing in
cifs_get_inode_info().


-- 
Peace and Blessings,
-Scott.
