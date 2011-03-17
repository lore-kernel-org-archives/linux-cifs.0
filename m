From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] wait_for_free_request needs to wait on credits returned
 by server for SMB2
Date: Thu, 17 Mar 2011 09:43:35 -0500
Message-ID: <AANLkTinVm3=iNm5fc+y7vevn8Ni92of8hSyP3DKGazSx@mail.gmail.com>
References: <AANLkTimsJ+vQm7XuVk2NHneRc04CeWebuG3jsLxML4sd@mail.gmail.com>
	<20110317143608.GC3295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110317143608.GC3295-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 9:36 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
>> =A0#ifdef CONFIG_CIFS_STATS2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->num_=
waiters);
>> @@ -283,6 +284,20 @@ static int wait_for_free_request(struct
>> TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->num_=
waiters);
>> =A0#endif
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Loc=
k);
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->is_smb2 &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (atomic_read(&server->=
credits) < 1)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> +#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->num_wa=
iters);
>> +#endif
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->request=
_q,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ato=
mic_read(&server->credits) > 0);
>> +#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->num_wa=
iters);
>> +#endif
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock)=
;
>> +#endif /* CONFIG_CIFS_SMB2 */
>
> This ifdef mania is madness. =A0Please make sure to hide the stats
> and smb2 code in properly abstracted helpers that get compiled out if
> not actually used.

I don't mind that change, and I agree it would make it more readable.
The stats ifdef
was used as cifs uses it to keep consistency initially.


--=20
Thanks,

Steve
