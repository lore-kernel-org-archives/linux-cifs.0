From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Fix build failure with smb2
Date: Tue, 4 Apr 2017 02:23:50 -0500
Message-ID: <CAH2r5mv-b5s-T38+h_gnb4cB_zYndFw6Ukk56KbT_O4t6FoooA@mail.gmail.com>
References: <20170330103414.19972-1-tobias.regnery@gmail.com> <mps1stfhtph.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mps1stfhtph.fsf@aaptelpc.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git

thx

On Thu, Mar 30, 2017 at 6:47 AM, Aur=C3=A9lien Aptel
<aurelien.aptel@gmail.com> wrote:
> Tobias Regnery <tobias.regnery@gmail.com> writes:
>> Explicit include the right header to fix this issue.
>
> uuid.h indeed declares generate_random_uuid(). Looks good to me.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
