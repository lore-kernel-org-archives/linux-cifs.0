From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: vim reports file having changed
Date: Wed, 30 Nov 2011 19:42:41 -0600
Message-ID: <CADT32eKDtm0sGk8TWp9zvELaK+Fw_PSinSpGR2S_epw7_pXu9g@mail.gmail.com>
References: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Johannes_Thr=E4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 30, 2011 at 8:25 AM, Johannes Thr=E4n
<johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> Hi all,
>
> I reported this before here, it somehow went under. So I'll try again=
:
>
> When I open a file which is located on a cifs-mounted windows share
> with vim, vim will after some time always report the file as having
> changed upon saving, regardless whether it has actually changed or
> not.
>
> I reported this also to the vim maintainer who told me, there he
> doesn't know of a similar problem with samba. Ergo it's probably a
> problem with cifs.
> I work on a daily basis with mentioned setup, so I would be vary glad
> to help resolve it.
>
> mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2
>
> best regard, Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

What is the version of cifs and what is the Windows server?
