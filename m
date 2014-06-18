From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs SRV record
Date: Wed, 18 Jun 2014 18:10:14 -0500
Message-ID: <CAH2r5ms5sf=vuv4QmiX6Kn6PB147M84RKKWxaEALOc-gkjHW7A@mail.gmail.com>
References: <1403101167.9166.6.camel@hh16.hh3.site> <0a840b51be30d5535ae0b7f59f83e5c1.squirrel@mail.balsover.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Bob Balsover <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0a840b51be30d5535ae0b7f59f83e5c1.squirrel-vQd1aa0lCeAC/Zx7Cl00UAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jun 18, 2014 at 5:01 PM, Bob Balsover <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org> wrote:
> Why not just use DFS? I believe that this is what it was designed for.
>
> -Bob


Yes.  DFS should be used for this.  Fairly easy to setup on server
(Samba or Windows or NetApp, although very different setup on Samba
than Windows) and the client supports it (whether Linux or Windows).



>> Hi
>> Is it possible to have cifs SRV rrs like ldap and kerberos where clients
>> can look for the service themselves? We'd like to be able to offer
>> shares on more than one server without the cluster stuff.
>>
>> ATM we have e.g.
>> mount -t cifs //server/share -owhatever
>>
>> Our question is, would having cifs SRV be a  way around having to
>> specify a specific server?



-- 
Thanks,

Steve
