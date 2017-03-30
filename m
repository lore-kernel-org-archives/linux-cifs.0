From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 2/2] net: dsa: dsa2: Add basic support of devlink
Date: Thu, 30 Mar 2017 08:17:06 +0200
Message-ID: <20170330061706.GA2010@nanopsycho>
References: <1490737507-7864-1-git-send-email-andrew@lunn.ch>
 <1490737507-7864-3-git-send-email-andrew@lunn.ch>
 <2fe7ffc9-1bf1-537a-e361-33156a6f5a07@gmail.com>
 <20170329013112.GF3152@lunn.ch>
 <c844a885-cfd3-4358-89dd-c619d3d394e4@gmail.com>
 <20170329173624.GE7942@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170329173624.GE7942@lunn.ch>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Wed, Mar 29, 2017 at 07:36:24PM CEST, andrew@lunn.ch wrote:
>> Tangential question: we do not currently report to user space what kind
>> of switch tagging protocol is used (DSA, eDSA etc.) I was going to add a
>> sysfs attribute for that under the switch device's directory, but maybe
>> devlink would be more appropriate for that?
>
>We don't report it. What are you thinking you want to do with this
>information?
>
>I suppose it might be possible to teach libpcap/tcpdump about it, so
>it can slide in an additional dissector. EDSA you can detect anyway,
>since it uses a well know Ethertype. tcpdump already supports
>this. But the other tag protocols cannot be detected.
>
>devlink does seem like a good candidate for this, make it part of the
>port type.

I agree this could go out via devlink. Not sure exactly what attr.
Certainly some new.


>
>     Andrew
