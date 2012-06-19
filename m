From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 4/5] CIFS: Move protocol specific session setup/logoff
 code to ops struct
Date: Tue, 19 Jun 2012 12:31:21 -0700
Message-ID: <CAH2r5mv8ZPm1_NcnO53yWOJ1RTqm5mSTet2GuOd3-HH_EiX4Pw@mail.gmail.com>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-5-git-send-email-pshilovsky@samba.org>
	<20120619085159.6bac54fa@corrin.poochiereds.net>
	<CAKywueSt2b5jYMNnnuGK+r_FPXifATBFfPGq9OeyycK8Y=sgGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSt2b5jYMNnnuGK+r_FPXifATBFfPGq9OeyycK8Y=sgGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jun 19, 2012 at 12:21 PM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org=
> wrote:
> 2012/6/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> On Sat, =A09 Jun 2012 10:26:03 +0400
>> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 +++++
>>> =A0fs/cifs/cifsproto.h | =A0 =A08 ++++----
>>> =A0fs/cifs/connect.c =A0 | =A0 16 +++++++++-------
>>> =A0fs/cifs/sess.c =A0 =A0 =A0| =A0 =A02 +-
>>> =A0fs/cifs/smb1ops.c =A0 | =A0 =A02 ++
>>> =A05 files changed, 21 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> index 669de88..812f27c 100644
>>> --- a/fs/cifs/cifsglob.h
>>> +++ b/fs/cifs/cifsglob.h
>>> @@ -196,6 +196,11 @@ struct smb_version_operations {
>>> =A0 =A0 =A0 bool (*need_neg)(struct TCP_Server_Info *);
>>> =A0 =A0 =A0 /* negotiate to the server */
>>> =A0 =A0 =A0 int (*negotiate)(const int, struct cifs_ses *);
>>> + =A0 =A0 /* setup smb sessionn */
>>> + =A0 =A0 int (*sess_setup)(const int, struct cifs_ses *,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_tabl=
e *);
>>> + =A0 =A0 /* close smb session */
>>> + =A0 =A0 int (*logoff)(const int, struct cifs_ses *);
>>> =A0};
>>>
>>> =A0struct smb_version_values {
>>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>>> index 32b569f..8e6cd38 100644
>>> --- a/fs/cifs/cifsproto.h
>>> +++ b/fs/cifs/cifsproto.h
>>> @@ -112,8 +112,8 @@ extern void header_assemble(struct smb_hdr *, c=
har /* command */ ,
>>> =A0extern int small_smb_init_no_tc(const int smb_cmd, const int wct=
,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
cifs_ses *ses,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void **=
request_buf);
>>> -extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct n=
ls_table *nls_cp);
>>> +extern int CIFS_SessSetup(const int xid, struct cifs_ses *ses,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_tabl=
e *nls_cp);
>>> =A0extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_=
since_1601);
>>> =A0extern u64 cifs_UnixTimeToNT(struct timespec);
>>> =A0extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_=
time,
>>> @@ -179,8 +179,8 @@ void cifs_proc_init(void);
>>> =A0void cifs_proc_clean(void);
>>>
>>> =A0extern int cifs_negotiate_protocol(const int xid, struct cifs_se=
s *ses);
>>> -extern int cifs_setup_session(unsigned int xid, struct cifs_ses *s=
es,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nls_table *nls_inf=
o);
>>> +extern int cifs_setup_session(const int xid, struct cifs_ses *ses,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nls_ta=
ble *nls_info);
>>> =A0extern int CIFSSMBNegotiate(const int xid, struct cifs_ses *ses)=
;
>>>
>>> =A0extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 4780342..9679352 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -2263,9 +2263,9 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>>> =A0 =A0 =A0 list_del_init(&ses->smb_ses_list);
>>> =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>>>
>>> - =A0 =A0 if (ses->status =3D=3D CifsGood) {
>>> + =A0 =A0 if (ses->status =3D=3D CifsGood && server->ops->logoff) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 xid =3D GetXid();
>>> - =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBLogoff(xid, ses);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 server->ops->logoff(xid, ses);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 _FreeXid(xid);
>>> =A0 =A0 =A0 }
>>> =A0 =A0 =A0 sesInfoFree(ses);
>>> @@ -3970,11 +3970,11 @@ cifs_negotiate_protocol(const int xid, stru=
ct cifs_ses *ses)
>>> =A0 =A0 =A0 return rc;
>>> =A0}
>>>
>>> -
>>> -int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nls_table *nls_inf=
o)
>>> +int
>>> +cifs_setup_session(const int xid, struct cifs_ses *ses,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct nls_table *nls_info)
>>
>
> Thanks for the review.
>
>>
>> While I think this whole "xid" thing is a bogus idea, if we're going=
 to
>> do it, we should at least try to be consistent about the type. _GetX=
id
>> returns unsigned int but you're turning that into a signed int here.
>>
>> I suggest that we don't do that. Let's declare henceforth that it's
>> unsigned. Any place that treats it as signed is a bug. We probably h=
ave
>> a lot of these bugs. I don't expect you to fix them all up, but you
>> should at least try to fix that up in the code that you're touching =
in
>> this series. We can get the rest later...
>>
>> Sound ok?
>>
>
> cifs_get_smb_ses has
>
> int xid;
>
> and does
>
> xid =3D GetXid();
>
> that returns 'int' - then it calls cifs_setup_session with this xid.
> It seems no problems with my patch here that converts
> cifs_setup_session to take an int.
>
> But GedXid() is
>
> =A042 #define GetXid()>------->------->------->------->------->------=
-\
> =A043 ({>----->------->------->------->------->------->------->------=
-\
> =A044 >-------int __xid =3D (int)_GetXid();>---->------->------->----=
---\
> =A045 >-------cFYI(1, "CIFS VFS: in %s as Xid: %d with uid: %d",>----=
-\
> =A046 >------- =A0 =A0 __func__, __xid, current_fsuid());>>------->--=
-----\
> =A047 >-------__xid;>->------->------->------->------->------->------=
-\
> =A048 })
>
> so, it assigns _GetXid to 'int' and returns sign int value - this
> confuse me a little. Why don't we return unsigned int here?

uint to int change in GetXid probably was an incorrect fix for some war=
ning
(and probably an old change).  Why not simply fix this to
return unsigned int in GetXid to be consistent.  As you noted
_GetXid returns unsigned int (and FreeXid wants an
unsigned int).   If we do a global fix to change
GetXid to be consistent - we can fix the name at the same
time (to remove camel case) if camel case still bugs people.

Of course - much of the GetXid and cFYI stuff could be removed
if we had dynamic trace points and a howto on how to use them
for cifs - someone started looking at this for various fs three or
four years ago but don't think they finished.
--=20
Thanks,

Steve
