From: Steve Finley <Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org>
Subject: Re: many-to-one nested CIFS serving
Date: Tue, 18 Sep 2012 09:32:36 -0600
Message-ID: <50589414.8000305@colostate.edu>
References: <50579A12.7070805@colostate.edu> <20120917165233.0e8d75a7@corrin.poochiereds.net>
Reply-To: Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120917165233.0e8d75a7-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
> On Mon, 17 Sep 2012 15:45:54 -0600
> Steve Finley <Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org> wrote:
>
>   
>> To Whom:
>>
>> I am exploiting a feature of the CIFS server that works for the client under
>> Windows 8 (not sure about others), but does not work for the linux client
>> under RedHat/CentOS5/6.
>>
>> I am mounting multiple Thecus NAS devices via CIFS, making
>> symbolic links to files on those NAS devices, where I reorganize the
>> directory structure, and then turn around and serve the top level
>> of that directory via CIFS.
>>
>> On a Windows machine I only have to mount that top level directory, and
>> the symbolic links automatically resolve themselves without having to also
>> mount the NAS device(s).  THIS IS VERY POWERFUL.  On a linux
>> machine however, the symbolic links can only be resolved if I have the
>> NAS devices mounted, and the mount points have to be named as shown
>> in the link.  It seems that the protocol necessary for this to work under
>> Windows has not been added to the linux version of the client.
>>
>> When I surf the web for others exploiting this feature, I find nothing.
>>
>> Thanks
>>
>> Steve Finley
>> Research Associate
>> CIRA - Colorado State University
>>
>>     
>
> So you're reexporting a CIFS mount from a linux box with samba? Yuck.
>
> Most likely you're running afoul of the fact that when POSIX extensions
> are enabled, that symlinks are passed on as-is to the client. If you
> mount from the clients using "nounix" it'll probably do something
> closer to what you expect.
>
> In truth though, I think you'd be better served by researching and
> configuring a DFS share.
>
>   
Jeff,

Thanks.  The nounix option did what I wanted.  Yes a bit "yucky" but 
this is all
read-only, and the "expensive" part of creating links really reorganizes 
the data in a way
that allows the scientists to browse it.  I will have a good look at 
DFS, since we
absolutely have a future need for such a beast.

Steve
