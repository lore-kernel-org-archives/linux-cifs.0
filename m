From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: Split ntlm and ntlmv2 authentication methods
 off CIFS_SessSetup()
Date: Thu, 1 May 2014 15:01:01 -0500
Message-ID: <CADT32e+VHgmUJoZfR0FJfhBGMLHzG0EfsFDAP+Ex2ikT9353LA@mail.gmail.com>
References: <1398948065-23265-1-git-send-email-sprabhu@redhat.com>
	<1398948065-23265-3-git-send-email-sprabhu@redhat.com>
	<CADT32e+uuZbXhGyCujnZ2Ed+2nihJeRMduZvqD21yCH=_i-YhA@mail.gmail.com>
	<1398961591.3528.8.camel@sachin-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398961591.3528.8.camel@sachin-laptop>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 1, 2014 at 11:26 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2014-05-01 at 10:31 -0500, Shirish Pargaonkar wrote:
>
>> > +
>> > +out:
>> > +       sess_data->result = rc;
>> > +       sess_data->func = NULL;
>> > +       sess_free_buffer(sess_data);
>> > +       sess_establish_session(sess_data);
>> > +       kfree(ses->auth_key.response);
>> > +       ses->auth_key.response = NULL;
>> > +}
>>
>> In all three sess_auth_* functions (ntlm, ntlmv2, and lanman (in
>> previous patch),
>> we will end up calling sess_establish_session() even if there is an error i.e.
>> sess_data->result is not 0.
>
> We check for any errors within sess_establish_session() before we
> attempt to establish session.
>
> static int
> sess_establish_session(struct sess_data *sess_data)
> {
> ..
>         if (!sess_data->result) {
>                 //Establish Session.
>         }
> ..
> }
>
> This isn't a technical issue but maybe considered a style issue.

Sure, would have preferred to call the function before goto lables, but will
leave at that.

>
>
>> > +       if (phase == NtLmChallenge) {
>> > +               rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
>> > +               /* now goto beginning for ntlmssp authenticate phase */
>>
>> I think this comment should move to after if statement
>> (it was at wrong place to begin with) i.e. go to authenticate phase
>> only if rc is NULL.
>
> I agree. The comment is actually not required.
>
> Sachin Prabhu
>
