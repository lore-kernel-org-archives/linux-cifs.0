From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Fri, 04 Nov 2011 11:04:59 +0530
Message-ID: <4EB37983.3080607@suse.com>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com> <20111101060428.5d474bb9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101060428.5d474bb9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/01/2011 03:34 PM, Jeff Layton wrote:
> On Tue, 1 Nov 2011 00:12:21 +0100
> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Hi,
>>
>> I would like to test the multiusermounts?
>>
>> I know to set:
>>
>>  echo 1 > /proc/fs/cifs/MultiuserMount
>>
>> and add an option to the mount command, but I can remember/read somewhere
>> that one have to add some mapping somehwere:
>>
>> local user : remote user
>> ...
>>
>> Is this correct?
>>
> 
> No. The MultiuserMount code that the above switch activates is
> basically deprecated (and never worked very well in the first place).

So, time for planning its good riddance?

> The correct way to do this is to use sec=krb5 and mount with '-o
> multiuser'. Then, make sure all users accessing the mount have a TGT.
> 
> If you're using unix extensions (generally meaning that the remote
> server is samba-based), then having unity-mapped uids is helpful.
> 
