From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6] cifs: obtain file access during backup intent lookup
Date: Fri, 28 Sep 2012 10:48:01 -0400
Message-ID: <CAFB9KM1ZA_eMFVQeFwG9ZsX8WuTi3uUFu1kQGec6-QGCu=fkUw@mail.gmail.com>
References: <1348777282-6385-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348777282-6385-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 27, 2012 at 4:21 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Rebased and resending the reviewed patch.
> Removed Reviewed by Jeff Layton since patch is slightly different
> i.e. there is a change to smb1ops.c to cifs query_dir_first operation.
>
> Path based querries can fail for lack of access, especially during lookup
> during open.
> open itself would actually succeed becasue of back up intent bit
> but querries (either path or file handle based) do not have a means to
> specifiy backup intent bit.
> So querry the file info during lookup using
>  trans2 / findfirst / file_id_full_dir_info
> to obtain file info as well as file_id/inode value.

Minor nitpick.  I like the patch, but the commit message misspells
"queries" a couple of times (sorry to be "that guy"). :)
(sending to list, correctly formatted this time.)
-- 
Peace and Blessings,
-Scott.
