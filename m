From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: fix automount for DFS shares
Date: Mon, 17 Oct 2011 09:16:37 -0500
Message-ID: <CAH2r5mufZzsOgPRrbnU+FXjZ+=R0UoyooMQwbu-+5h6=Sav_4g@mail.gmail.com>
References: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
	<1318845543-15085-2-git-send-email-gerlando.falauto@keymile.com>
	<20111017064542.036ff6bb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017064542.036ff6bb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Would you respin to add the reviewed-by (and any more you got) and fix
the comment

On Mon, Oct 17, 2011 at 5:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 17 Oct 2011 11:59:03 +0200
> Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org> wrote:
>
>> Automounting directories are now invalidated by .d_revalidate()
>> so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
>> flag
>>
>> Signed-off-by: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
>> ---
>> =A0fs/cifs/dir.c | =A0 =A07 ++++++-
>> =A01 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index 9ea65cf..67f54d3 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -637,8 +637,13 @@ cifs_d_revalidate(struct dentry *direntry, stru=
ct nameidata *nd)
>> =A0 =A0 =A0 if (direntry->d_inode) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_revalidate_dentry(direntry))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We want automonting ino=
des to be
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* considered invalid or=
 so */
>
> The comment is a little unclear. A better comment might be -- "Forcib=
ly
> invalidate automounting inodes", or something along those lines...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_AUTOMOUNT(direntry-=
>d_inode))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /*
>
> The patch itself looks reasonable though...
>
> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
