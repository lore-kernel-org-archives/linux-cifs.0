From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs, cifs: convert tcon_link.tl_count from atomic_t to refcount_t
Date: Wed, 1 Nov 2017 12:56:29 -0500
Message-ID: <CAH2r5mtWf5mxKjPNsBs5TRAaPJMaPKwnWTMYz6o49_+K_zGk_g@mail.gmail.com>
References: <1508496110-2292-1-git-send-email-elena.reshetova@intel.com> <mpstvygispl.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Elena Reshetova <elena.reshetova@intel.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mpstvygispl.fsf@aaptelpc.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Oct 30, 2017 at 10:03 AM, Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> Elena Reshetova <elena.reshetova@intel.com> writes:
>> atomic_t variables are currently used to implement reference
>> counters with the following properties:
>>  - counter is initialized to 1 using atomic_set()
>>  - a resource is freed upon counter reaching zero
>>  - once counter reaches zero, its further
>>    increments aren't allowed
>>  - counter schema uses basic atomic operations
>>    (set, inc, inc_not_zero, dec_and_test, etc.)
>>
>> Such atomic variables should be converted to a newly provided
>> refcount_t type and API that prevents accidental counter overflows
>> and underflows. This is important since overflows and underflows
>> can lead to use-after-free situation and be exploitable.
>>
>> The variable tcon_link.tl_count is used as pure reference counter.
>> Convert it to refcount_t and fix up the operations.
>
> <snip>
>
>> -             cifs_get_tlink(tlink);
>> +             refcount_set(&tlink->tl_count, 1);
>
> Since cifs_get_tlink() basically only increments the reference count and
> given that this is a new tlink I also think this replacement is ok.
>
> Looks good to me and passes 'make C=3D1'.
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
