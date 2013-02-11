From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS: Unexpected SMB signature
Date: Mon, 11 Feb 2013 14:26:54 -0600
Message-ID: <CADT32eK-oi=7ScnAUFsc9D2nuUj6pmpRgEjuvZ998gVYPF4s7Q@mail.gmail.com>
References: <2022205250.283066.1360587245710.JavaMail.www@wwinf8224>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2022205250.283066.1360587245710.JavaMail.www@wwinf8224>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 11, 2013 at 6:54 AM, sergio.conrad
<sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:
> Hi,
> I still have a problem with Unexpected SMB signature with CIFS as des=
cribed in https://bugzilla.samba.org/show_bug.cgi?id=3D9477.
>
> Could it be related with the windows 2008 domain controllers policy "=
digitally sign communications (always)" ?
>
> Thanks,
> Serge Conrad
>
>
>
> Une messagerie gratuite, garantie =E0 vie et des services en plus, =E7=
a vous tente ?
> Je cr=E9e ma bo=EEte mail www.laposte.net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I think you need this installed on your Windows 2008 server.

   http://support.microsoft.com/kb/957441

Regards,

Shirish
