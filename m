From: Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org>
Subject: Re: Kerberized mount.cifs with SMB>1?
Date: Mon, 20 Oct 2014 19:19:55 +0200
Message-ID: <5445443B.2090807@rug.nl>
References: <53F4ABCD.5040909@rug.nl> <1408545832.2071.6.camel@hh16.hh3.site> <53F4D7FC.8020405@rug.nl> <544417CA.3000609@rug.nl> <54441E2A.6020809@steve-ss.com> <54441F79.7040804@rug.nl> <54442233.4090801@steve-ss.com> <54442399.5030100@rug.nl> <54453737.7040403@steve-ss.com> <54453A48.1050208@rug.nl> <CAH2r5msA2D8upKSYVUEC1ygULe9oGa2x0XR5tGeF59bSmjKa3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msA2D8upKSYVUEC1ygULe9oGa2x0XR5tGeF59bSmjKa3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/20/2014 07:09 PM, Steve French wrote:
> On Mon, Oct 20, 2014 at 11:37 AM, Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org> wrote:
>> On 10/20/2014 06:24 PM, steve wrote:
>>> On 19/10/14 22:48, Jurjen Bokma wrote:
>>>> On 10/19/2014 10:42 PM, steve wrote:
>>>>> On 19/10/14 22:30, Jurjen Bokma wrote:
>>>>>
>>>>>> So I would very much like to use SMB3 to get to the Windows file
>>>>>> servers. Kerberized SMB1 worked like a charm. Speed/bandwidth is not
>>>>>> really the issue here.
>>>>>>
>>>>> Yeah, of course. Never knew there was any security involved. Worrying.
>>>> Did you ever have SMB3 working Kerberized? If I know it's supposed to
>>>> work, I'll give up less easily.
>>>>
>>> Hi
>>> We have everything default. We'd no idea that smb3 existed until this
>>> thread. Anyway, it doesn't work here either:
>>> CIFS VFS: cifs_mount failed w/return code = -128
>>> I think the Kerberos has worked because that codes means that the ticket
>>> has expired, except it hasn't because removing vers=3.0 mounts fine.
>>> But we don't know if our Samba4 file servers are capable of it anyway. I
>>> think we'd have to change something in smb.conf.
>> Maybe to serve SMB3. Max protocol comes to mind. But editing smb.conf is
>> not likely necessary to merely mount a share I presume? IME mount.cifs +
>> Kerberos will work once krb5.conf and request-key are properly
>> configured, regardless of the smb.conf on the client.
>> I did fiddle a bit with /proc/fs/cifs/* though.
>>
>>> Maybe the devs will look if you bugzilla it?
>> Will try. But first I'll take a look myself, lest I don't know what to ask.
> 
> It is doable, and probably easier since the cleanup/rewrite a year or so ago
> of some of the auth code.
> 
> Note that for cifs dialect (in fs/cifs/cifssmb.c) the negotiate response calls
> decode_negTokenInit to parse the asn1 to figure out if kerberos is
> allowed (see around line 595 and following of fs/cifs/asn1.c) then compare
> with the smb2/smb3 case in which we call decode_neg_token_init
> in line 434 of fs/cifs/smb2pdu.c during the processing of the SMB2/SMB3
> negotiate protocol response.  Note that this is ifdef out (CONFIG_SMB2_ASN1)
> since this function has to be changed to match the new format
> 
> Perhaps simply changing
> 
> decode_neg_token_init(security_blob, blob_length, &server->sec_type)
> to
> decode_negTokenInit(security_blob, length, server);
> 
> would get you through negotiate protocol then the only change needed
> would be to SMB2_sess_setup (see lines 526 and following of fs/cifs/smb2pdu.c)
> to parse the asn1 in a similar way to what we do for cifs dialect
> in fs/cifs/sess.c routine sess_auth_kerberos (see liones 543 and later).
> 
> It shouldn't be too bad to finish up.
> 
> Then once negprot and session setup are working with Kerberos then
> the simple use cases (SMB2 and SMB2.1 with signing disabled) should work
> and then for the other use cases will also have to check if SMB2.1/SMB3 signing
> needs changing for krb5 (don't know, probably not) and if
> smb3_validate_negotiate
> needs any minor changes for the krb5 case.
> 
That was just the sort of intro I needed right now. Don't expect
immediate results from me though. I must cram this in between other tasks.

Thanks!
Jurjen
