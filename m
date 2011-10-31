From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Mon, 31 Oct 2011 18:14:56 -0500
Message-ID: <CAH2r5mvarY9rstVCOwXDp63Dx+kARTc2c89YWio=aNJz5MsppA@mail.gmail.com>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff has a writeup that explains it more nicely but don't have the
link in front of me.  Note that it works best with Kerberos (sec=3Dkrb5
or sec=3Dkrb5i)

On Mon, Oct 31, 2011 at 6:12 PM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I would like to test the multiusermounts?
>
> I know to set:
>
> =A0echo 1 > /proc/fs/cifs/MultiuserMount
>
> and add an option to the mount command, but I can remember/read somew=
here
> that one have to add some mapping somehwere:
>
> local user : remote user
> ...
>
> Is this correct?
>
> Stef Bon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
