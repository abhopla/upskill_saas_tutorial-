class ContactsController < ApplicationController
  # GET request to /contact-us
  #show new contact form 
  def new
    @contact = Contact.new
  end
  #POST request /contacts
  def create
    #Mass assignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    #save the contact object to the database
    if @contact.save
      #store form fields via parameters into variables 
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      #Plug variables into contact mailer
      #email method and send email
      ContactMailer.contact_email(name,email,body).deliver
      #Store success massage in flash hash
      #and redirect to new action
      flash[:success] = "Message Sent"
      redirect_to new_contact_path 
    else
      #If contact object doesn't save store errors in flash hash
      #redirect to new path
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  private
  #To collect data from form,
  #Using strong parameters 
  #Whitelist the form fields 
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end