From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: Process post session setup code in respective
 dialect functions.
Date: Fri, 6 Sep 2013 08:36:15 -0500
Message-ID: <CADT32eKAKVDO9c1Le6gTLDB_8oYUgnpQof+Dq3WtvdsjiSZegg@mail.gmail.com>
References: <1377783311-3924-1-git-send-email-shirishpargaonkar@gmail.com>
	<1377783311-3924-2-git-send-email-shirishpargaonkar@gmail.com>
	<20130906091117.5fc36bd4@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130906091117.5fc36bd4-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks Jeff. Sure, noted.

Regards,

Shirish

On Fri, Sep 6, 2013 at 8:11 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 29 Aug 2013 08:35:09 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Move the post (successful) session setup code to respective dialect routines.
>>
>> For smb1, session key is per smb connection.
>> For smb2/smb3, session key is per smb session.
>>
>> If client and server do not require signing, free session key for smb1/2/3.
>>
>> If client and server require signing
>>   smb1 - Copy (kmemdup) session key for the first session to connection.
>>          Free session key of that and subsequent sessions on this connection.
>>   smb2 - For every session, keep the session key and free it when the
>>          session is being shutdown.
>>   smb3 - For every session, generate the smb3 signing key using the session key
>>          and then free the session key.
>>
>> There are two unrelated line formatting changes as well.
>> ---
>>  fs/cifs/connect.c | 27 +--------------------------
>>  fs/cifs/misc.c    |  1 +
>>  fs/cifs/sess.c    | 40 +++++++++++++++++++++++++++++++++++++---
>>  fs/cifs/smb2pdu.c | 31 +++++++++++++++++++++++++++++++
>>  4 files changed, 70 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index d67c550..84a7bde 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3826,33 +3826,8 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>>       if (server->ops->sess_setup)
>>               rc = server->ops->sess_setup(xid, ses, nls_info);
>>
>> -     if (rc) {
>> +     if (rc)
>>               cifs_dbg(VFS, "Send error in SessSetup = %d\n", rc);
>> -     } else {
>> -             mutex_lock(&server->srv_mutex);
>> -             if (!server->session_estab) {
>> -                     server->session_key.response = ses->auth_key.response;
>> -                     server->session_key.len = ses->auth_key.len;
>> -                     server->sequence_number = 0x2;
>> -                     server->session_estab = true;
>> -                     ses->auth_key.response = NULL;
>> -                     if (server->ops->generate_signingkey)
>> -                             server->ops->generate_signingkey(server);
>> -             }
>> -             mutex_unlock(&server->srv_mutex);
>> -
>> -             cifs_dbg(FYI, "CIFS Session Established successfully\n");
>> -             spin_lock(&GlobalMid_Lock);
>> -             ses->status = CifsGood;
>> -             ses->need_reconnect = false;
>> -             spin_unlock(&GlobalMid_Lock);
>> -     }
>> -
>> -     kfree(ses->auth_key.response);
>> -     ses->auth_key.response = NULL;
>> -     ses->auth_key.len = 0;
>> -     kfree(ses->ntlmssp);
>> -     ses->ntlmssp = NULL;
>>
>>       return rc;
>>  }
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index f7d4b22..82a2b9f 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -105,6 +105,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
>>       }
>>       kfree(buf_to_free->user_name);
>>       kfree(buf_to_free->domainName);
>> +     kfree(buf_to_free->auth_key.response);
>>       kfree(buf_to_free);
>>  }
>>
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 08dd37b..7afd54a 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -629,7 +629,8 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
>>       type = select_sectype(ses->server, ses->sectype);
>>       cifs_dbg(FYI, "sess setup type %d\n", type);
>>       if (type == Unspecified) {
>> -             cifs_dbg(VFS, "Unable to select appropriate authentication method!");
>> +             cifs_dbg(VFS,
>> +                     "Unable to select appropriate authentication method!");
>>               return -EINVAL;
>>       }
>>
>> @@ -815,8 +816,9 @@ ssetup_ntlmssp_authenticate:
>>               ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>>                                                GFP_KERNEL);
>>               if (!ses->auth_key.response) {
>> -                     cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory",
>> -                                     msg->sesskey_len);
>> +                     cifs_dbg(VFS,
>> +                             "Kerberos can't allocate (%u bytes) memory",
>> +                             msg->sesskey_len);
>>                       rc = -ENOMEM;
>>                       goto ssetup_exit;
>>               }
>> @@ -1005,5 +1007,37 @@ ssetup_exit:
>>       if ((phase == NtLmChallenge) && (rc == 0))
>>               goto ssetup_ntlmssp_authenticate;
>>
>> +     if (!rc) {
>> +             mutex_lock(&ses->server->srv_mutex);
>> +             if (!ses->server->session_estab) {
>> +                     if (ses->server->sign) {
>> +                             ses->server->session_key.response =
>> +                                     kmemdup(ses->auth_key.response,
>> +                                     ses->auth_key.len, GFP_KERNEL);
>> +                             if (!ses->server->session_key.response) {
>> +                                     rc = -ENOMEM;
>> +                                     mutex_unlock(&ses->server->srv_mutex);
>> +                                     goto keycp_exit;
>> +                             }
>> +                             ses->server->session_key.len =
>> +                                                     ses->auth_key.len;
>> +                     }
>> +                     ses->server->sequence_number = 0x2;
>> +                     ses->server->session_estab = true;
>> +             }
>> +             mutex_unlock(&ses->server->srv_mutex);
>> +
>> +             cifs_dbg(FYI, "CIFS session established successfully\n");
>> +             spin_lock(&GlobalMid_Lock);
>> +             ses->status = CifsGood;
>> +             ses->need_reconnect = false;
>> +             spin_unlock(&GlobalMid_Lock);
>> +     }
>> +
>> +keycp_exit:
>> +     kfree(ses->auth_key.response);
>> +     ses->auth_key.response = NULL;
>> +     kfree(ses->ntlmssp);
>> +
>>       return rc;
>>  }
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index abc9c28..05a0186 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -478,6 +478,13 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>>       }
>>
>>       /*
>> +      * If we are here due to reconnect, free per-smb session key
>> +      * in case signing was required.
>> +      */
>> +     kfree(ses->auth_key.response);
>> +     ses->auth_key.response = NULL;
>> +
>> +     /*
>>        * If memory allocation is successful, caller of this function
>>        * frees it.
>>        */
>> @@ -628,6 +635,30 @@ ssetup_exit:
>>       /* if ntlmssp, and negotiate succeeded, proceed to authenticate phase */
>>       if ((phase == NtLmChallenge) && (rc == 0))
>>               goto ssetup_ntlmssp_authenticate;
>> +
>> +     if (!rc) {
>> +             mutex_lock(&server->srv_mutex);
>> +             if (!server->session_estab) {
>> +                     server->sequence_number = 0x2;
>> +                     server->session_estab = true;
>> +                     if (server->ops->generate_signingkey)
>> +                             server->ops->generate_signingkey(server);
>> +             }
>> +             mutex_unlock(&server->srv_mutex);
>> +
>> +             cifs_dbg(FYI, "SMB2/3 session established successfully\n");
>> +             spin_lock(&GlobalMid_Lock);
>> +             ses->status = CifsGood;
>> +             ses->need_reconnect = false;
>> +             spin_unlock(&GlobalMid_Lock);
>> +     }
>> +
>> +     if (!server->sign) {
>> +             kfree(ses->auth_key.response);
>> +             ses->auth_key.response = NULL;
>> +     }
>> +     kfree(ses->ntlmssp);
>> +
>>       return rc;
>>  }
>>
>
> Nice cleanup. I think this looks reasonable.
>
> Another possible cleanup in the future might be to get rid of the
> ses->ntlmssp field. Since it's only used during session setup, it would
> probably be better to pass that in as a separate parm, but that can and
> should be done in a later patch.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
