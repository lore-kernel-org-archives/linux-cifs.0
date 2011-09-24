From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: should we change the name of get/setcifsacl ?
Date: Sat, 24 Sep 2011 12:36:09 -0500
Message-ID: <CAH2r5mtBm7mUzO05JjND8=Tp0tc7_oFG0dkZO9y=mR_7UMYzxQ@mail.gmail.com>
References: <20110924083751.111d85a7@tlielax.poochiereds.net>
	<CADT32eKZKKmo+aEp4P9tFkJNfUY=oueW=6=-gUe_5sxEYS9Fiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKZKKmo+aEp4P9tFkJNfUY=oueW=6=-gUe_5sxEYS9Fiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I mildly prefer get/setcifsacl (shorter) but don't have a strong
opinion on the tool name.

On Sat, Sep 24, 2011 at 12:05 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sat, Sep 24, 2011 at 7:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > The nfs4 ACL tools are called nfs4_getfacl and nfs4_setfacl. I thin=
k it
> > would probably be good for consistency's sake to change the name of=
 the
> > cifs variants to cifs_getfacl and cifs_setfacl.
> >
> > Any thoughts or objections?
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>
> I have no objection/preference for the tools' names.
> But there is getfacl and setfacl. And I think richacl has tool/s
> such as setrichacl.
>
> Regards,
>
> Shirish
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve
