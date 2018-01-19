From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always be signed
Date: Fri, 19 Jan 2018 14:23:22 +0100
Message-ID: <87lggux9rp.fsf@suse.com>
References: <20171031095530.520746935@linuxfoundation.org> <20171031095531.633196173@linuxfoundation.org> <97340c9a-0ea2-0d3d-cf26-58c799d76cae@mageia.org> <20171101151803.GB31285@kroah.com> <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu> <47c8ba0a-f576-8ebe-1cb5-71ab80f77db7@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lsahlber@redhat.com, pshilov@microsoft.com,
        linux-cifs@vger.kernel.org
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>,
        Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <47c8ba0a-f576-8ebe-1cb5-71ab80f77db7@csail.mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi,

"Srivatsa S. Bhat" <srivatsa@csail.mit.edu> writes:
>> Any thoughts on what is the right fix for stable kernels? Mounting SMB3
>> shares works great on mainline (v4.15-rc5). It also works on 4.4.109 if
>> I pass the sec=ntlmsspi option to the mount command (as opposed to the
>> default: sec=ntlmssp). Please let me know if you need any other info.

Make sure you have (in that order):

db3b5474f462 ("CIFS: Fix NULL pointer deref on SMB2_tcon() failure")
fe83bebc0522 ("SMB: fix leak of validate negotiate info response buffer")
a2d9daad1d2d ("SMB: fix validate negotiate info uninitialised memory use")
4587eee04e2a ("SMB3: Validate negotiate request must always be signed")
a821df3f1af7 ("cifs: fix NULL deref in SMB2_read")

Does enabling CIFS_SMB311 changes anything?

I also suspect some things assume encryption patches are in.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
