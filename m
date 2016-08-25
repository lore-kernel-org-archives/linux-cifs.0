From: Isaac Boukris <iboukris@gmail.com>
Subject: Re: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of the
 cifs.upcall krb5 handling code
Date: Thu, 25 Aug 2016 19:05:48 +0300
Message-ID: <CAC-fF8S_K49oDzNMQ8PrjWyWEokdsRo2gC5xUQobWe4TTBYaCA@mail.gmail.com>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs@vger.kernel.org, jfdey@fredhutch.org,
 samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1472134665-4014-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

Hello,

On Thu, Aug 25, 2016 at 5:17 PM, Jeff Layton <jlayton@samba.org> wrote:
> While this is a step in the right direction, what I think we might
> want to do longer-term is to make this use gss_init_sec_context
> instead of micromanaging it like we do now. The only part I'm a
> little unclear on is how to extract the session key in that case.


Coincidentally, I was thinking the same way recently that it could be
better to use GSSAPI in cifs upcall.
The idea is to save to trouble of SPNEGO wrapping and to allow real
KRB and NTLM negotiation in userspace.

After some fiddling I managed to make something work using MIT Kerberos library.
First I call gss_init_sec_context() with GSS_C_NO_OID so I get a raw
KRB token and it returns GSS_S_COMPLETE (since I didn't ask for mutual
auth and using KRB mech and not SPNEGO).

Then I call the below (found mentioned on mailing list archive):

maj = gss_inquire_sec_context_by_oid(&min, context,

GSS_C_INQ_SSPI_SESSION_KEY,
                                                         &skey);
if (GSS_ERROR(maj) || skey == GSS_C_NO_BUFFER_SET || !skey->count) {
    syslog(LOG_DEBUG, "%s: failed to inquire for session key (%d)",
__func__, maj);
    goto done;
}

*sess_key = data_blob(skey->elements[0].value, skey->elements[0].length);

This works against my test server (win2k3) since it seem to accept raw
KRB tokens (similar to servers that accept raw NTLMSSP I guess, the
token is probably passed to an equivalent of gss_accept_sec_context()
which can identify the mechanism).

However, it gets more complicated when it comes to SPNEGO.
First, when I call gss_init_sec_context with SPNEGO mech it will
always return GSS_S_CONTINUE_NEEDED as it need server response in
order to complete (even if mutual auth is not requested).
This causes (I think) the call to gss_inquire_sec_context_by_oid to fail.
Also, we need to support continuation anyway for mutual auth and NTLM fallback.

So I thought I'd use gss_export_sec_context() when we get
continuation-needed and send the serialized context back to the
kernel, which in its turn will send it back to the next upcall once it
receives server's response, which in its turn will import back the
context till it completes and then export the session key.
However, unfortunately the spec does not guarantee the export to
succeed with a partial context (not completed).
In practice the MIT library seem to allow export of a partial KRB
context (where the continuation is only needed for mutual auth) but
does not allow export of a partial SPNEGO context.
I've asked about it on MIT's IRC channel and was pointed out to PR
#356 which adds support for exporting partial SPNEGO context, so I'm
currently trying this patch but I'm unsure where this PR stands in
terms of MIT team priorities.

Thanks for reading :)

Regards,
Isaac B.
