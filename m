From: Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org>
Subject: Re: Kerberized mount.cifs with SMB>1?
Date: Mon, 20 Oct 2014 18:37:28 +0200
Message-ID: <54453A48.1050208@rug.nl>
References: <53F4ABCD.5040909@rug.nl> <1408545832.2071.6.camel@hh16.hh3.site> <53F4D7FC.8020405@rug.nl> <544417CA.3000609@rug.nl> <54441E2A.6020809@steve-ss.com> <54441F79.7040804@rug.nl> <54442233.4090801@steve-ss.com> <54442399.5030100@rug.nl> <54453737.7040403@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54453737.7040403-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/20/2014 06:24 PM, steve wrote:
> On 19/10/14 22:48, Jurjen Bokma wrote:
>> On 10/19/2014 10:42 PM, steve wrote:
>>> On 19/10/14 22:30, Jurjen Bokma wrote:
>>>
>>>> So I would very much like to use SMB3 to get to the Windows file
>>>> servers. Kerberized SMB1 worked like a charm. Speed/bandwidth is not
>>>> really the issue here.
>>>>
>>> Yeah, of course. Never knew there was any security involved. Worrying.
>> Did you ever have SMB3 working Kerberized? If I know it's supposed to
>> work, I'll give up less easily.
>>
> Hi
> We have everything default. We'd no idea that smb3 existed until this
> thread. Anyway, it doesn't work here either:
> CIFS VFS: cifs_mount failed w/return code = -128
> I think the Kerberos has worked because that codes means that the ticket
> has expired, except it hasn't because removing vers=3.0 mounts fine.
> But we don't know if our Samba4 file servers are capable of it anyway. I
> think we'd have to change something in smb.conf.
Maybe to serve SMB3. Max protocol comes to mind. But editing smb.conf is
not likely necessary to merely mount a share I presume? IME mount.cifs +
Kerberos will work once krb5.conf and request-key are properly
configured, regardless of the smb.conf on the client.
I did fiddle a bit with /proc/fs/cifs/* though.

> Maybe the devs will look if you bugzilla it?
Will try. But first I'll take a look myself, lest I don't know what to ask.

Thx so far!
Jurjen
